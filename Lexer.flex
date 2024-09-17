/* JFlex example: part of Java language lexer specification */
import java_cup.runtime.*;
import java_cup.runtime.Symbol;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;

/**
* This class is a simple example lexer.
*/
%%
%public
%class Lexer
%unicode
%cup
%implements sym, Constants
%line
%column
%char
/*%standalone*/
%{
    StringBuffer string = new StringBuffer();
    ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();

    public static int Counter = 1;

    private void print(String text, int line, int column, String type){
        System.out.printf("%03d- %s\t\t  Line %02d\t\t Col %02d\t\t Content = [%s]\n", Counter++, type, line, column, text );
    }

    public Lexer(java.io.Reader in, ComplexSymbolFactory sf){
    	this(in);
    	symbolFactory = sf;
    }

      private Symbol symbol(String name, int sym) 
    {
     //   System.out.printf("Founded token: %s\n", name);
        return symbolFactory.newSymbol(name, sym, new Location(yyline+1,yycolumn+1,(int)yychar), new Location(yyline+1,yycolumn+yylength(),(int)yychar+yylength()));
    }

    private Symbol symbol(String name, int sym, Object val)
    {
    //    System.out.printf("Founded token: %s\n", name);
        Location left = new Location(yyline+1,yycolumn+1,(int)yychar);
        Location right= new Location(yyline+1,yycolumn+yylength(), (int)yychar+yylength());
        return symbolFactory.newSymbol(name, sym, left, right,val);
    }

    private Symbol symbol(String name, int sym, Object val,int buflength)
     {
      //  System.out.printf("Founded token: %s\n", name);
        Location left = new Location(yyline+1,yycolumn+yylength()-buflength,(int)yychar+yylength()-buflength);
        Location right= new Location(yyline+1,yycolumn+yylength(), (int)yychar+yylength());
        return symbolFactory.newSymbol(name, sym, left, right,val);
    }



%}

// ============ General Rules ============
LineTerminator       = \r|\n|\r\n
InputCharacter       = [^\r\n]
WhiteSpace           = {LineTerminator} | [ \t\f]
Semi                 = ";"

// ============ Comments ============

Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}
TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
CommentContent       = ( [^*] | \*+ [^/*] )*
DocumentationComment = "/**" {CommentContent} "*"+ "/"

// ============ Identifier ============
Alpha=[A-Za-z]
Digit=[0-9]
Identifier = {Alpha}({Alpha}|{Digit}|_)*

// ============ Numbers ============
IntegerNumber    = ([\+\-]?)(0|[1-9][0-9]*)
FloatLiteral          = [+-]?[0-9]* (\. [0-9]+)
DoubleLiteral = [+-]?[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?
//Double
// ============= others ==============
Reserved = {println} | {inumber} | {CLEAR}


%state STRING
%%
// ============ Keywords ============
<YYINITIAL> "function"         { return symbol("function",      TypeDef                               ); }
<YYINITIAL> "void"             { return symbol("void",       Type,         new Integer(TypeVoid)   ); }
<YYINITIAL> "string"           { return symbol("string",     Type,         new Integer(TypeString) ); }
<YYINITIAL> "int"              { return symbol("int",        Type,         new Integer(TypeInt)    ); }
<YYINITIAL> "float"            { return symbol("float",        Type,         new Integer(TypeFloat)    ); }

<YYINITIAL> "double"              { return symbol("double",        Type,         new Integer(TypeDouble)    ); }


// double and float and char
<YYINITIAL> "new"              { return symbol("new",        MemDef                                ); }
<YYINITIAL> "for"              { return symbol("for",        FOR                               ); }
<YYINITIAL> "in"               { return symbol("in",         IN                                    ); }
<YYINITIAL> "if"               { return symbol("if",         IF                                    ); }
<YYINITIAL> "else"             { return symbol("else",       ELSE                                  ); }
<YYINITIAL> "elsif"            { return symbol("elsif",      ELSIF                                  ); }
<YYINITIAL> "switch"           { return symbol("switch",     SWITCH                                 ); }
<YYINITIAL> "case"             { return symbol("case",       CASE                                 ); }
<YYINITIAL> "true"             { return symbol("true",       TRUE                                  ); }
<YYINITIAL> "false"            { return symbol("false",      FALSE                                 ); }
<YYINITIAL> "return"           { return symbol("return",     RETURN                               ); }
<YYINITIAL> "while"            { return symbol("while",      WHILE                                 ); }
<YYINITIAL> "main()"           { return symbol("EntryPoint", EntryPoint                            ); }
<YYINITIAL> "continue"         { return symbol("continue",   CONTINUE                                 ); }
<YYINITIAL> "break"            { return symbol("break",      BREAK                                 ); }
<YYINITIAL> "and"              { return symbol("and",        AND                                 ); }
<YYINITIAL> "or"               { return symbol("or",         OR                                 ); }
<YYINITIAL> "do"               { return symbol("do",         DO                                 ); }
<YYINITIAL> "println"          { return symbol("println",    PRINTLN                                 ); }
<YYINITIAL> "clear"            { return symbol("clear",      CLEAR                                 ); }


<YYINITIAL> {

// ============ Identifier ============
{Identifier}                   { return symbol("Identifier", sym.Identifier, yytext()                 ); }

// ============ Numbers ============
// Toye parsereton terminale NUMVALUE Nadarin. vase
// in che gohi khorde akhe? :\ zamani ke adadet ashari bashe adade ro save nmikone, on maghadire constant ro save mikone!
// generate this
{FloatLiteral}                  { return symbol("Float",      NumValue, java.lang.Float.valueOf(yytext())     ); }
{DoubleLiteral}                  { return symbol("Double",      NumValue,     java.lang.Double.valueOf(yytext())    ); }
{IntegerNumber}            { return symbol("DecInt",     NumValue,     Integer.parseInt(yytext()) ); }


// ============ String Init  ============
\"                             { string.setLength(0); yybegin(STRING); }

// ============ Delimiters ============
// 
{Semi}                         { return symbol(";",          SEMICOLON                                ); }
"("                            { return symbol("(",          OPAR                                ); }
")"                            { return symbol(")",          CPAR                               ); }
"{"                            { return symbol("{",          OBLOCK                          ); }
"}"                            { return symbol("}",          CBLOCK                            ); }
"["                            { return symbol("[",          OBRACE                          ); }
"]"                            { return symbol("]",          CBRACE                          ); }
":"                            { return symbol(":",          COLON                               ); }
","                            { return symbol(",",          COMMA                               ); }

// ============ Operators ============


"**"                           { return symbol ("Power",     POWER                                  );} 
"="                            { return symbol("=",          ASSIGN                              ); }
"=="                           { return symbol("Eq",         COMPARATOR, new Integer(Eq)         ); }
"!="                           { return symbol("NotEq",      sym.NEQ, new Integer(NotEq)      ); }
"++"                           { return symbol("PlusPlus",   PLUSPLUS                            ); }
"+"                            { return symbol("Plus",       PLUS,   new Integer(Plus)       ); }
"--"                           { return symbol("MinusMinus", MINUSMINUS                          ); }
"-"                            { return symbol("Minus",      MINUS,   new Integer(Minus)      ); }
"*"                            { return symbol("Mult",       MULT,   new Integer(Mult)       ); }
">"                            { return symbol("GrT",        COMPARATOR, new Integer(GrT)        ); }
"<"                            { return symbol("LoT",        COMPARATOR, new Integer(LoT)        ); }
"|"                            { return symbol("Or",         OR, new Integer(Or)         ); }
"/"                            { return symbol("Divide",     DIVIDE,   new Integer(Divide)     ); }
"^"                            { return symbol("NNot",       NNOT                           ); }
"!"                            { return symbol("Not",        NOT,   new Integer(Not)        ); }
"."                            { return symbol("Dot",        DOT                                 ); }
"&"                            { return symbol("and",        AND                                 ); }  
"%"                            { return symbol("Modulo",     MODULO                                ); }   
"<>"                           { return symbol("AngleBracket",  ANGBR                                ); } 
"<="                           { return symbol("LoTEq",         LTEQ                                 ); } 
">="                           { return symbol("GrTEq",         GTEQ                                 ); }  
"||"                           { return symbol("or",             OR                                 ); }
"&&"                           { return symbol("and",           AND                                 ); }
// ":="                           { return symbol("Asignn",        ASIGNN,                             ); }  





// ============ Comments ============
{Comment}                      { /* ignore */ }

// ============ Whitespace ============
{WhiteSpace}                   { /* ignore */ }
}

// ============ String Rules ============
<STRING> {
\"                             {
                                 yybegin(YYINITIAL);
                                 return symbol("StringConst", StringConst, string.toString(), string.length());
                               }

[^\n\r\"\\]+                   { string.append( yytext() ); }
\\t                            { string.append('\t'); }
\\n                            { string.append('\n'); }
\\r                            { string.append('\r'); }
\\\"                           { string.append('\"'); }
\\                             { string.append('\\'); }
}

// ============ Error Fallback ============
[^]                            { throw new Error("Parsing Failed! Illegal character ["+ yytext()+"] at line " + yyline + ", col " + yycolumn); }