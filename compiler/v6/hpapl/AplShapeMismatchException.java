package hpapl;

public class AplShapeMismatchException extends RuntimeException {
	
	AplArray a, b;
	
	public AplShapeMismatchException(AplArray a, AplArray b) {
		this.a = a;
		this.b = b;
	}
	
}
