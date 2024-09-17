import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;

public class Main
{
    public static void main(String[] args)
    {
        if(args.length != 1){
            System.out.println("> You should exactly have one argument for file name. Program terminates.");
            return;
        }
        String fileName = args[0];
        Lexer scanner = null;

        try{
            FileInputStream fioStream = new FileInputStream(fileName);
            Reader fioReader = new InputStreamReader(fioStream);
            scanner = new Lexer(fioReader);

            Parser parser = new Parser(scanner);


            parser.parse();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
    }
}