import java.nio.file.*;
import java.io.IOException;
public class C{
  public static void main(String[]d)throws IOException{
    Path i=Paths.get(d[0]),o=Paths.get(d[1]);
    Files.createDirectories(o);
    Files.walk(i).filter(Files::isRegularFile).forEach(p->{
      try{
        String f=p.getFileName().toString();
        Path t=o.resolve(f);
        int c=1;
        while(Files.exists(t)){
          int k=f.lastIndexOf('.');
          String b=k>0?f.substring(0,k):f;
          String e=k>0?f.substring(k):"";
          t=o.resolve(b+"_"+c+e);
          c++;
        }
        Files.copy(p,t);
      }catch(IOException e){}
    });
  }
}
