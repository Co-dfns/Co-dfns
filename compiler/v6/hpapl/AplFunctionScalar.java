package hpapl;

public abstract class AplFunctionScalar extends AplFunction {

	public AplFunctionScalar() {
		super();
	}
	
	public AplFunctionScalar(AplOperand lop, AplOperand rop, AplOperand... env) {
		super(lop, rop, env);
	}
	
}
