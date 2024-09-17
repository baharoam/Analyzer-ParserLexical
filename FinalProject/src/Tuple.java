public class Tuple<K, V>
{
    private K element0;
    private V element1;

    public Tuple(K element0, V element1)
    {
        this.element0 = element0;
        this.element1 = element1;
    }

    public void setElement0(K value)
    {
        this.element0 = value;
    }

    public void setElement1(V value)
    {
        this.element1 = value;
    }
    public K getElement0() {
        return element0;
    }

    public V getElement1() {
        return element1;
    }

}