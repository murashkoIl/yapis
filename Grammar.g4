grammar grLang;

//////////////////

MAIN: 'main';
OPEN_BRACKET: '(';
CLOSE_BRACKET: ')';
OPEN_SQUARE_BRACKET: '[';
CLOSE_SQUARE_BRACKET: ']';
OPEN_CURLY_BRACKET: '{';
CLOSE_CURLY_BRACKET: '}';

//////////////////

INT: 'int';
NODE: 'node';
EDGE: 'edge';
GRAPH: 'graph';
edgeExpression : OPEN_CURLY_BRACKET LINE COMMA NAME COMMA NAME CLOSE_CURLY_BRACKET;
graphExpressionPart : ((OPEN_CURLY_BRACKET (NAME COMMA)* (NAME) CLOSE_CURLY_BRACKET)
                                         | (OPEN_CURLY_BRACKET CLOSE_CURLY_BRACKET));
graphExpression : OPEN_CURLY_BRACKET graphExpressionPart graphExpressionPart CLOSE_CURLY_BRACKET;

//////////////////


PRINT: 'print';
IN: 'in';
IF: 'if';
ELSE: 'else';
WHILE: 'while';
FOR: 'for';
FUNCTION: 'function';
RETURN: 'return';
SIZE: 'size';
GET: 'get';

//////////////////

PLUS: '+';
MINUS: '-';
MULTIPLY: '*';
DIVIDE: '/';
DOT: '.';
EQULS: '=';
COMMA: ',';

//////////////////


LESS: '<';
GREATER: '>';
NEGATION : '!';
EQUAL: '==';
NON_EQUAL: '!=';

//////////////////

SPACE: [ \n\t\r]+ -> skip;

//////////////////

NAME: [a-zA-Z_][a-zA-Z_0-9]* ;
NUMBER: [0-9]+ ;
LINE: '"'(.)+?'"';

//////////////////

program: MAIN block (functionReturn|functionNonReturn)*;
block: OPEN_CURLY_BRACKET content* CLOSE_CURLY_BRACKET;
declarationNode: NODE? NAME EQULS (LINE|functionCall|getExpression);
declarationEdge: EDGE? NAME EQULS (functionCall|edgeExpression);
declarationGraph: GRAPH? NAME EQULS (functionCall|graphExpression);

//////////////////

print: PRINT OPEN_BRACKET LINE CLOSE_BRACKET;
printGraph: PRINT OPEN_BRACKET NAME CLOSE_BRACKET;

//////////////////

inputSignature: OPEN_BRACKET (NAME COMMA)* NAME CLOSE_BRACKET;
functionCall: (NAME (inputSignature|(OPEN_BRACKET CLOSE_BRACKET)));

//////////////////

type: GRAPH|NODE|EDGE;
signatureFunction: OPEN_BRACKET (type NAME COMMA)* (type NAME) CLOSE_BRACKET;
functionReturn: FUNCTION type NAME (signatureFunction|(OPEN_BRACKET CLOSE_BRACKET)) blockReturn;
functionNonReturn: FUNCTION NAME (signatureFunction|(OPEN_BRACKET CLOSE_BRACKET)) blockNonReturn;

//////////////////

blockReturn: OPEN_CURLY_BRACKET content* RETURN NAME CLOSE_CURLY_BRACKET;
blockNonReturn: OPEN_CURLY_BRACKET content* CLOSE_CURLY_BRACKET;

//////////////////

equalCompare: (expression) (EQUAL|NON_EQUAL) (expression);
compare: (sizeExpression) (EQUAL|NON_EQUAL|LESS|GREATER) (sizeExpression);
simpleCompare: equalCompare|compare;
negationCompare: NEGATION OPEN_BRACKET simpleCompare CLOSE_BRACKET;
elseBlock: ELSE block;
ifBlock: IF OPEN_BRACKET (simpleCompare|negationCompare) CLOSE_BRACKET block elseBlock?;

//////////////////

whileBlock: WHILE OPEN_BRACKET NAME IN NAME CLOSE_BRACKET block;

//////////////////

sizeExpression: NAME DOT SIZE OPEN_BRACKET CLOSE_BRACKET;
getExpression: NAME DOT GET OPEN_BRACKET NUMBER CLOSE_BRACKET;

//////////////////

expression:
    |   graphExpression
    |   edgeExpression
    |   NAME PLUS NAME
    |   NAME MINUS NAME
    |   NAME MULTIPLY NAME
    |   NAME DIVIDE NAME
    |   NAME
    |   getExpression
    |   functionCall
    ;

//////////////////

content :
    |   print
    |   declarationNode
    |   declarationEdge
    |   declarationGraph
    |   printGraph
    |   ifBlock
    |   whileBlock
    |   functionCall
    ;