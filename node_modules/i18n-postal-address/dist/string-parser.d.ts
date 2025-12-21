import type { ParserOutput, Parsers } from './types/address-format';
interface StringParserConfig {
    parser: Parsers;
}
declare class StringParser {
    private parser;
    private previousInput;
    private previousOutput;
    constructor(config: StringParserConfig);
    parse(input: string): ParserOutput;
}
export default StringParser;
