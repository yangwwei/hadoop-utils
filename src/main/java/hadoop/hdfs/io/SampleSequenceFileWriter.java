package hadoop.hdfs.io;
import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.SequenceFile;
import org.apache.hadoop.io.Text;

public class SampleSequenceFileWriter {
  public static void main(String[] args) throws IOException {
    Configuration conf = new Configuration();
    conf.set("fs.hdfs.impl", 
        "org.apache.hadoop.hdfs.DistributedFileSystem");
    conf.addResource(new Path("file:///Users/yangwwei/Documents/workspace/Test/resource/hdfs-site.xml"));
    conf.addResource(new Path("file:///Users/yangwwei/Documents/workspace/Test/resource/core-site.xml"));   
    Path path = new Path("/tmp/seq-test");
    IntWritable key = new IntWritable();
    Text value = new Text();
    SequenceFile.Writer writer = null;
    try {
      writer = SequenceFile.createWriter(
          conf,
          SequenceFile.Writer.file(path),
          SequenceFile.Writer.keyClass(IntWritable.class),
          SequenceFile.Writer.valueClass(Text.class));
      for (int i = 0; i < 100; i ++) { 
        key.set(100 - i);
        value.set("This is a sample sequence file");
        writer.append(key, value);  
      } 
    } finally {
      IOUtils.closeStream( writer); 
    }  
  } 
}

