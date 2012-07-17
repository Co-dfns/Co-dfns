package hpapl.examples;

import hpapl.*;
import hpapl.AplArray.*;
import java.io.*;

public class IotaSumReduceDemo {
	
	private static class Anon extends AplFunction {
		public void apply(AplArray out, AplArray rgt) {
			AplArray res = new AplArray();
			AplFunctionPrimitive plus = new AplArray.PlusFunction();
			
			res.reduceIota(plus, rgt);
			out.setFrom(0, res, 0);
		}
		
		public void apply(AplArray out, AplArray lft, AplArray rgt) {
			throw new AplValenceException();
		}
	}
	
	/* ⎕←⊃⌽{+/⍳⍵}¨⍳count */
	public static void main(String[] args) 
	throws InterruptedException {
		AplArray res;
		AplFunction fun;
		
		// Thread.sleep(5000);
		
		int count = 100000;
		
		fun = new Anon();
		res = new AplArray();
		
		res.iota(count);
		res.each(fun, res);
		
		System.out.println(res.getInt(count - 1));
	}
}
