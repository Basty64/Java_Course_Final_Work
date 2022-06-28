package First_release;

import com.google.gson.Gson;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;



public class Parser {

            public List<Layer> parsjson(String str) {
                Gson gson = new Gson();
                List<Layer> result = new ArrayList<>();
                try {
                    Data data = gson.fromJson(new FileReader(str), Data.class);
                    result = data.getDataList();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
}




