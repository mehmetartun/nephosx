import cv2
import numpy as np
import sys
import os
import argparse
import base64
import csv

def make_white_transparent(img):
    """
    Identifies white areas in an image and replaces them with full transparency (Alpha=0).
    It returns the BGRA image and the mask used for identifying the white background.
    """
    
    # 1. Convert to BGRA (Blue, Green, Red, Alpha) to add the transparency channel
    img_bgra = cv2.cvtColor(img, cv2.COLOR_BGR2BGRA)

    # 2. Convert to HSV to easily target white color
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    # Define the color range for 'white' in HSV.
    # High Value (Brightness) and low Saturation are key for white.
    # H: 0-180 (Full Range), S: 0-30 (Low Saturation), V: 200-255 (High Brightness)
    lower_white = np.array([0, 0, 200], dtype=np.uint8)
    upper_white = np.array([180, 30, 255], dtype=np.uint8)

    # 3. Create the mask: Pixels in this range are set to white (255), others to black (0)
    mask = cv2.inRange(hsv, lower_white, upper_white)
    
    # --- NEW: only remove white regions that are connected to the image border ---
    # Convert mask to binary (0 or 1) for connected components
    bin_mask = (mask == 255).astype(np.uint8)

    # Label connected components in the white mask. Each connected white region gets a label > 0.
    # cv2.connectedComponents expects a single-channel 8-bit image where non-zero pixels are foreground.
    num_labels, labels = cv2.connectedComponents(bin_mask, connectivity=8)

    # If no white regions found, return original
    if num_labels <= 1:
        return img_bgra, mask

    # Collect labels that touch the image border (these are outer/background white regions)
    H, W = labels.shape
    border_labels = np.unique(
        np.concatenate((labels[0, :], labels[H-1, :], labels[:, 0], labels[:, W-1]))
    )

    # Remove the label 0 (background of the labels image) if present
    border_labels = border_labels[border_labels != 0]

    # Create a mask for white pixels that belong to border-connected components
    if border_labels.size == 0:
        # Nothing connected to border; don't remove internal whites
        bg_mask = np.zeros_like(mask, dtype=np.uint8)
    else:
        # Use numpy to build a boolean mask where pixels belong to any border label
        bg_mask = np.isin(labels, border_labels).astype(np.uint8) * 255

    # Set alpha to 0 for border-connected white background only
    img_bgra[bg_mask == 255] = [255, 255, 255, 0]

    # Return the BGRA image and the background mask (255 where outer white exists)
    return img_bgra, bg_mask

def crop_to_square(img_bgra, mask):
    """
    Crops the image to a square aspect ratio that tightly fits the non-transparent
    (object) content detected by the mask.
    """
    
    # Use the mask to find object boundaries. Inverting is crucial here 
    # because the mask has white (255) for the *background* we want to ignore.
    mask_inv = cv2.bitwise_not(mask)
    
    # Find contours
    # Note: The third return value is usually hierarchy, which we ignore with '_'
    contours, _ = cv2.findContours(mask_inv, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if not contours:
        # If no contours are found, return the original image
        return img_bgra

    # Find the bounding box of the largest contour (assumed to be the main object)
    max_contour = max(contours, key=cv2.contourArea)
    x, y, w, h = cv2.boundingRect(max_contour)
    
    # 5. Determine the size for the square crop (the larger of the width or height)
    side = max(w, h)
    
    # 6. Calculate new top-left coordinates for the square crop to center the object
    
    # Calculate padding needed to center the object within the square
    pad_x = (side - w) // 2
    pad_y = (side - h) // 2
    
    # Calculate crop coordinates based on the object's bounding box (x, y) 
    # and the calculated padding (pad_x, pad_y).
    x1 = max(0, x - pad_x)
    y1 = max(0, y - pad_y)
    
    # Calculate bottom-right coordinates
    x2 = x1 + side
    y2 = y1 + side
    
    # Handle edge cases where the new square might exceed the original image bounds
    # This prevents accessing array out of bounds.
    H, W = img_bgra.shape[:2]
    
    # If the calculated square goes past the boundary, shift it back.
    if x2 > W:
        x1 = W - side
        x2 = W
    if y2 > H:
        y1 = H - side
        y2 = H
    
    # Ensure starting coordinates are not negative
    x1 = max(0, x1)
    y1 = max(0, y1)

    # 7. Crop the image using array slicing (OpenCV's standard cropping method)
    cropped_img = img_bgra[y1:y2, x1:x2]

    return cropped_img


def resize_bgra_to_square(img_bgra, size=300):
    """
    Resize a BGRA image to a square of `size x size` pixels while preserving
    aspect ratio and alpha channel. The image is scaled so the longer side matches
    `size`, then centered on a transparent square canvas of (size, size).

    Args:
        img_bgra: numpy array with shape (H, W, 4) and dtype uint8.
        size: integer target size for both width and height (default 300).

    Returns:
        A new numpy array of shape (size, size, 4) with the resized image
        placed at the center and transparent background elsewhere.
    """
    if img_bgra is None:
        raise ValueError("img_bgra must be a valid BGRA image")

    H, W = img_bgra.shape[:2]

    # If already the target size, return a copy
    if H == size and W == size:
        return img_bgra.copy()

    # Compute scaling factor to fit the image into the square while preserving aspect
    scale = float(size) / max(H, W)

    new_w = max(1, int(round(W * scale)))
    new_h = max(1, int(round(H * scale)))

    # Choose interpolation: INTER_AREA for shrinking, INTER_LINEAR for enlarging
    interp = cv2.INTER_AREA if scale < 1.0 else cv2.INTER_LINEAR

    resized = cv2.resize(img_bgra, (new_w, new_h), interpolation=interp)

    # Create transparent square canvas
    canvas = np.zeros((size, size, 4), dtype=img_bgra.dtype)

    # Center the resized image on the canvas
    x = (size - new_w) // 2
    y = (size - new_h) // 2
    canvas[y:y+new_h, x:x+new_w] = resized

    return canvas

def image_to_base64(img, extension=".png"):
    """
    Encodes a cv2 image (numpy array) into a base64 string.

    Args:
        img: The image (as a numpy array) to encode.
        extension: The image format to use for encoding (e.g., '.png', '.jpg').
                   Defaults to '.png' to support transparency.

    Returns:
        A base64 encoded string of the image.
    """
    success, encoded_image = cv2.imencode(extension, img)
    if not success:
        raise ValueError("Could not encode image to memory.")
    
    return base64.b64encode(encoded_image).decode("utf-8")

def process_image(input_path,output_dir):
    # Read the image
    img = cv2.imread(input_path)

    if img is None:
        print(f"Error: Could not read image at '{input_path}'. Check if the file exists and is a valid image format.")
        sys.exit(1)

    print(f"Processing image: {input_path} (Original size: {img.shape[1]}x{img.shape[0]})")
    
    # 1. Remove white background and add transparency
    processed_img_bgra, alpha_mask = make_white_transparent(img)

    # 2. Crop to content with square aspect ratio
    final_square_img = crop_to_square(processed_img_bgra, alpha_mask)

    final_square_img = resize_bgra_to_square(final_square_img, size=300)

    # 3. Determine output path
    # Get just the filename from the full input path
    filename = os.path.basename(input_path)
    # Get the name without the extension
    base, ext = os.path.splitext(filename)
    # Construct the new filename and join it with the output directory path
    output_path = os.path.join(output_dir, base + ".png")
    
    # IMPORTANT: Must save as PNG to preserve the Alpha (transparency) channel
    cv2.imwrite(output_path, final_square_img)

    # Get the base64 string for the final image
    base64_string = image_to_base64(final_square_img)

    print(f"Successfully processed and saved to: {output_path}")
    print(f"Final size: {final_square_img.shape[1]}x{final_square_img.shape[0]}")
    return output_path, base64_string

def main():
    parser = argparse.ArgumentParser(
        description="Process images in a directory to remove the white background, crop to a square, and resize."
    )
    parser.add_argument("input_dir", help="Path to the directory containing images to process.")
    parser.add_argument("output_dir", help="Path to the directory containing images that have been processed")

    args = parser.parse_args()

    input_dir = args.input_dir
    output_dir = args.output_dir

    if not os.path.isdir(input_dir):
        print(f"Error: Provided path '{input_dir}' is not a valid directory.", file=sys.stderr)
        sys.exit(1)

    # Create the output directory if it doesn't exist
    if not os.path.isdir(output_dir):
        print(f"Output directory '{output_dir}' does not exist. Creating it.")
        os.makedirs(output_dir, exist_ok=True)

    # Define the path for the output CSV file
    csv_path = os.path.join(output_dir, "image_data.csv")

    # Write the header to the CSV file if it doesn't exist
    if not os.path.exists(csv_path):
        with open(csv_path, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['image_name', 'base64_string'])

    print(f"--- Starting image processing in directory: {input_dir} ---")
    supported_extensions = ('.png', '.jpg', '.jpeg')
    processed_count = 0

    for filename in sorted(os.listdir(input_dir)):
        if filename.lower().endswith(supported_extensions):
            try:
                image_path = os.path.join(input_dir, filename)
                _, base64_data = process_image(image_path, output_dir)
                processed_count += 1

                with open(csv_path, 'a', newline='', encoding='utf-8') as csvfile:
                    writer = csv.writer(csvfile)
                    writer.writerow([filename, base64_data])
            except Exception as e:
                print(f"Error processing {image_path}: {e}", file=sys.stderr)
    
    print(f"--- Finished. Processed {processed_count} image(s). ---")

if __name__ == "__main__":
    main()
