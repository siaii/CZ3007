/* You do not need to change anything up here. */
package lexer;

import frontend.Token;
import static frontend.Token.Type.*;
import java.util.Map;
import java.util.stream.*;

%%

%public
%final
%class Lexer
%function nextToken
%type Token
%unicode
%line
%column

%{
	/* These two methods are for the convenience of rules to create toke objects.
	* If you do not want to use them, delete them
	* otherwise add the code in 
	*/
	  Map<String, Token.Type> map = Stream.of(new Object[][] {
      { "boolean", BOOLEAN },
      { "break", BREAK },
      { "else", ELSE },
      { "false", FALSE },
      { "if", IF },
      { "import", IMPORT },
      { "int", INT },
      { "module", MODULE },
      { "public", PUBLIC },
      { "return", RETURN },
      { "true", TRUE }, 
      { "type", TYPE },
      { "void", VOID },
      { "while", WHILE },
 		}).collect(Collectors.toMap(data -> (String) data[0], data -> (Token.Type) data[1]));
 
	private Token token(Token.Type type) {
		return new Token(type, yyline, yycolumn, yytext());
	}
	
	/* Use this method for rules where you need to process yytext() to get the lexeme of the token.
	 *
	 * Useful for string literals; e.g., the quotes around the literal are part of yytext(),
	 *       but they should not be part of the lexeme. 
	*/
	private Token token(Token.Type type, String text) {
		return new Token(type, yyline, yycolumn, text.replace("\"", ""));		
	}
	
	private Token lookUp(String text){
		if(map.containsKey(text)){
			return token(map.get(text));
		}
		return token(ID, text);
	}
%}

/* This definition may come in handy. If you wish, you can add more definitions here. */
WhiteSpace = [ ] | \t | \f | \n | \r
Digit = [0-9]
Alpha = [a-zA-Z]

%%
/* put in your rules here.    */

"," 						{ return token(COMMA); }
"[" 						{ return token(LBRACKET); }
"{" 						{ return token(LCURLY); }
"(" 						{ return token(LPAREN); }
"]" 						{ return token(RBRACKET); }
"}" 						{ return token(RCURLY); }
")" 						{ return token(RPAREN); }
";" 						{ return token(SEMICOLON); }

"/" 						{ return token(DIV); }
"==" 						{ return token(EQEQ); }
"=" 						{ return token(EQL); }
">=" 						{ return token(GEQ); }
">" 						{ return token(GT); }
"<=" 						{ return token(LEQ); }
"<" 						{ return token(LT); }
"-" 						{ return token(MINUS); }
"!=" 						{ return token(NEQ); }
"+" 						{ return token(PLUS); }
"*" 						{ return token(TIMES); }

{Alpha}({Alpha}|{Digit})* 	{ return lookUp(yytext()); }
{Digit}+ 					{ return token(INT_LITERAL,  yytext()); }
\"[^\n\"]*\"				{ return token(STRING_LITERAL, yytext()); }

{WhiteSpace} 				{}



/* You don't need to change anything below this line. */
.							{ throw new Error("unexpected character '" + yytext() + "'"); }
<<EOF>>						{ return token(EOF); }
