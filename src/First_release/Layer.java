package First_release;
import java.util.ArrayList;


public class Layer {

    private ArrayList z_layer;
    private ArrayList y_color;
    private ArrayList x_color;

    public Layer(ArrayList z, ArrayList y, ArrayList x) {
        this.z_layer = z;
        this.y_color = y;
        this.x_color = x;
    }

    public ArrayList getZ_layer() {
        return z_layer;
    }

    public ArrayList getY_color() {
        return y_color;
    }

    public ArrayList getX_color() {
        return x_color;
    }
}





