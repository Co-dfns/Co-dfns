package hpapl.examples;

import hpapl.*;

public class LargeSum {
	
	public static void main(String[] args) {
	
		AplArray res = new AplArray();
		
		res.iota(500000000);
		res.plus(res, res);
		
		System.out.println(res.getSize());
		
	}
	
}
