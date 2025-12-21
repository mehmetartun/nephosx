import type { PostalLabels, PostalResult } from 'node-postal';
import type { ParserMap } from './address-mappings';
import type { ParserInterface, ParserOutput } from './types/address-format';
declare const addressParsers: {
    array: ParserInterface<"array">;
    string: null;
};
export declare const parseLibpostal: (mapping: ParserMap<PostalLabels>, result: PostalResult[]) => ParserOutput;
export default addressParsers;
