## Responsible for generating a function call to a custom evaluator.
<%page args="evaluator,expected,actual,arguments" />
import java.util.*;

public class EvaluatorExecutor {

    public static void main(String[] args) throws Exception {
        try (AbstractCustomEvaluator eval = new ${evaluator}()) {
            eval.evaluate(
                <%include file="literal.mako" args="value=expected"/>,
                <%include file="literal.mako" args="value=actual"/>,
                <%include file="literal.mako" args="value=arguments"/>
            );
        }
    }
}
