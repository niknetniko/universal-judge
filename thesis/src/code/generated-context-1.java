public class Context_0_0 {

    private final FileWriter valueWriter;
    private final FileWriter exceptionWriter;

    public Context_0_0() throws Exception {
        this.valueWriter = new FileWriter("TDm75Wrze_values.txt");
        this.exceptionWriter = new FileWriter("TDm75Wrze_exceptions.txt");
    }

    private void send(Object value) throws Exception {
        Values.send(valueWriter, value);
    }

    private void sendE(Exception exception) throws Exception {
        Values.sendException(exceptionWriter, exception);
    }

    private void vEvaluate0(Object value) throws Exception { send(value); }

    private void eEvaluate0(Exception value) throws Exception { sendE(value); }

    void execute() throws Exception {
        try {
            this.vEvaluate0(Main.loterij(6, 15));
        } catch (Exception e) {
            this.eEvaluate0(e);
        }
        System.err.print("--TDm75Wrze-- SEP");
        System.out.print("--TDm75Wrze-- SEP");
        valueWriter.write("--TDm75Wrze-- SEP");
        exceptionWriter.write("--TDm75Wrze-- SEP");
    }

    void close() throws Exception {
        this.valueWriter.close();
        this.exceptionWriter.close();
    }

    public static void main(String[] a) throws Exception {
        var context = new Context_0_1();
        context.execute();
        context.close();
    }
}