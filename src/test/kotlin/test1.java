
class Circle {
    private int redius;
    Circle(int redius) {
        this.redius = redius;
    }
    public void show() {
        System.out.println("반지름이 " + redius + "인 원이다");
    }
}
class ColoredCircle extends Circle {
    String color;
    int redius;

    ColoredCircle(int redius, String color) {
        super(redius);
        this.color = color;

    }
    public void show() {
        System.out.println("반지름이 " + redius + "인" + color + " 원이다");
    }
}
class test1 {
    public static void main(String[] args) {
        Circle circle = new Circle(5);
        circle.show();

        ColoredCircle coloredCircle = new ColoredCircle(5,"빨간색");
        coloredCircle.show();
    }
}