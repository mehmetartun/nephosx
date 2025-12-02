import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum EntityType { company, datacenter }

@JsonEnum(fieldRename: FieldRename.snake)
enum Country {
  us(
    "US",
    "USA",
    "United States of America",
    true,
    1,
    AddressRegion.europeWest,
  ),
  ca("CA", "CAN", "Canada", true, 1, AddressRegion.europeWest),
  uk("UK", "GBR", "United Kingdom", false, 1, AddressRegion.europeWest),
  fr("FR", "FRA", "France", false, 1, AddressRegion.europeWest),
  de("DE", "GER", "Germany", false, 1, AddressRegion.europeWest);

  final String iso2;
  final String iso3;
  final String description;
  final bool hasStates;
  final int numLines;
  final AddressRegion region;

  const Country(
    this.iso2,
    this.iso3,
    this.description,
    this.hasStates,
    this.numLines,
    this.region,
  );
}

@JsonEnum(fieldRename: FieldRename.snake)
enum AddressRegion {
  europeWest("europe-west", "Western Europe"),
  europeCentral("europe-central", "Central Europe");

  final String title;
  final String description;

  const AddressRegion(this.title, this.description);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum AddressState {
  bcca("BC", Country.ca, "British Columbia"),
  caus("CA", Country.us, "California"),
  azus("AZ", Country.us, "Arizona");

  final String title;
  final Country country;
  final String description;

  const AddressState(this.title, this.country, this.description);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum ServingFormat {
  glass,
  mug,
  bottle,
  can,
  shot,
  tumbler,
  longGlass,
  cocktailGlass,
  wineGlass,
  champagneFlute,
  pilsnerGlass,
  snifter,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum DrinkType { cocktail, beer, wine, spirit, bubbly, cider }

@JsonEnum(fieldRename: FieldRename.snake)
enum DrinkSize {
  smallGlass(125.0, 'Small', [DrinkType.wine, DrinkType.bubbly]),
  mediumGlass(175.0, 'Medium', [DrinkType.wine]),
  largeGlass(250.0, 'Large', [DrinkType.wine]),
  amount330ml(330.0, '33 cl', [DrinkType.beer, DrinkType.cider]),
  amount500ml(500.0, '50 cl', [DrinkType.beer, DrinkType.cider]),
  amount250ml(250.0, '25 cl', [DrinkType.beer, DrinkType.cider]),
  amount300ml(300.0, '30 cl', [DrinkType.beer, DrinkType.cider]),
  amount200ml(200.0, '20 cl', [DrinkType.beer, DrinkType.cider]),
  amount1l(1000.0, '1 liter', [DrinkType.beer, DrinkType.cider]),
  amountPint(568.0, 'UK Pint', [DrinkType.beer, DrinkType.cider]),
  amountHalfPint(284.0, 'UK \u00BD Pint', [DrinkType.beer, DrinkType.cider]),
  amount8oz(237.0, '8 oz', [DrinkType.beer, DrinkType.cider]),
  amount12oz(355.0, '12 oz', [DrinkType.beer, DrinkType.cider]),
  amount16oz(473.0, 'US Pint', [DrinkType.beer, DrinkType.cider]),
  amount20oz(591.0, '20 oz', [DrinkType.beer, DrinkType.cider]),
  amount440ml(440.0, '44 cl', [DrinkType.beer, DrinkType.cider]),
  oneCocktail(0.0, 'One Glass', [DrinkType.cocktail]),
  singleShot(50.0, 'Single', [DrinkType.spirit]),
  doubleShot(100.0, 'Double', [DrinkType.spirit]);

  final double volumeInML;
  final String description;
  final List<DrinkType> drinkTypes;

  const DrinkSize(this.volumeInML, this.description, this.drinkTypes);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum DrinkCompany {
  alone("Alone"),
  friends("Friends"),
  family("Family"),
  colleagues("Colleagues"),
  event("Event Participants");

  const DrinkCompany(this.title);
  final String title;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum DrinkLocation {
  home("Home"),
  bar("Bar"),
  work("Work"),
  club("Night Club"),
  restaurant("Restaurant"),
  event("Event"),
  houseParty("House Party"),
  travel("Travelling");

  final String title;

  const DrinkLocation(this.title);
}

enum ErrorType {
  loginError("Login Error");

  final String description;
  const ErrorType(this.description);
}

enum UserType {
  public("Public", "User that doesn't belong to a company"),
  admin("Admin", "NephosX admin user"),
  corporate("Corporate", "A corporate user that belongs to a company"),
  corporateAdmin("Corporate Admin", "A corporate user that has admin rights");

  final String description;
  final String title;
  const UserType(this.title, this.description);
}

enum Currency {
  usd("USD", "United States Dollar"),
  eur("EUR", "Euro"),
  gbp("GBP", "British Pound"),
  jpy("JPY", "Japanese Yen");

  final String description;
  final String title;
  const Currency(this.title, this.description);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum RequestStatus { pending, inReview, accepted, rejected }

@JsonEnum(fieldRename: FieldRename.snake)
enum RequestType {
  createCompany("Create Company", UserType.public, UserType.admin),
  joinCompany("Join Company", UserType.public, UserType.corporateAdmin),
  authorizeCompany(
    "Authorize Company",
    UserType.corporateAdmin,
    UserType.admin,
  );

  final String description;
  final UserType requestorType;
  final UserType approverType;

  const RequestType(this.description, this.requestorType, this.approverType);
}
