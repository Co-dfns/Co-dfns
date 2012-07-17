package hpapl;

public abstract class AplFunction extends AplOperand {
	
	protected AplOperand lop;
	protected AplOperand rop;
	protected AplOperand[] env;
	
	public AplFunction() {
		this.lop = null;
		this.rop = null;
		this.env = new AplOperand[0];
	}
	
	public AplFunction(AplOperand lop, AplOperand rop, AplOperand... env) {
		this.lop = lop;
		this.rop = rop;
		this.env = env;
	}
	
	public abstract void apply(AplArray out, AplArray rgt);
	public abstract void apply(AplArray out, AplArray lft, AplArray rgt);
}
