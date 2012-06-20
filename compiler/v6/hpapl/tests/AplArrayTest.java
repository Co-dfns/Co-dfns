package hpapl.tests;

import org.junit.*;
import static org.junit.Assert.*;
import hpapl.*;

public class AplArrayTest {
	
	AplArray empty;
	AplArray vector_empty;
	AplArray scalar_zero;
	AplArray matrix_empty;
	AplArray noble_empty;
	
	AplArray iota_scalar_res;
	AplArray plus_iota;
	AplArray scalar;
	AplArray plus_scalar;
	AplArray each_id;
	AplArray each_id_scalar;
	AplArray reduce_arr;
	
	AplFunction id_fun;
	AplFunctionScalar id_fun_scalar;
	AplFunction plus;
	
	int iota_scalar_in = 49;
	int[] scalar_shape = {};
	int scalar_value = 7;
	
	private class IdFunction extends AplFunction {
		public void apply(AplArray out, AplArray rgt) {
			out.copy(rgt);
		}
		public void apply(AplArray out, AplArray lft, AplArray rgt) {
			apply(out, rgt);
		}
	}
	
	private class IdFunctionScalar extends AplFunctionScalar {
		public void apply(AplArray out, AplArray rgt) {
			out.copy(rgt);
		}
		public void apply(AplArray out, AplArray lft, AplArray rgt) {
			apply(out, rgt);
		}
	}
	
	@Before public void setupEmptyArray() {
		empty = new AplArray();
		scalar_zero = new AplArray(0);
		matrix_empty = new AplArray(2);
		vector_empty = new AplArray(1);
		noble_empty = new AplArray(3);

		iota_scalar_res = new AplArray();
		iota_scalar_res.iota(iota_scalar_in);
		
		scalar = new AplArray(scalar_shape);
		scalar.set(0, scalar_value);
		
		plus_iota = new AplArray();
		plus_iota.plus(iota_scalar_res, iota_scalar_res);
				
		plus_scalar = new AplArray();
		plus_scalar.plus(scalar, iota_scalar_res);
		
		each_id = new AplArray();
		each_id_scalar = new AplArray();
		id_fun = new IdFunction();
		each_id.each(id_fun, plus_scalar);
		id_fun_scalar = new IdFunctionScalar();
		each_id_scalar.each(id_fun_scalar, plus_scalar); 
		
		reduce_arr = new AplArray();
		plus = new AplArray.PlusFunction();
		reduce_arr.reduce(plus, iota_scalar_res);
	}
	
	@Test public void allEmpty() {
		assertTrue(empty.isEmpty());
		assertTrue(vector_empty.isEmpty());
		assertTrue(matrix_empty.isEmpty());
		assertTrue(noble_empty.isEmpty());
	}
	
	@Test public void scalarNotEmpty() {
		assertFalse(scalar_zero.isEmpty());
	}
	
	@Test public void emptyVerifyShape() {
		int[] shp = {0};
		
		assertArrayEquals(shp, empty.getShape());
	}
	
	@Test public void emptyRankOne() {
		assertTrue(1 == empty.rank());
	}
	
	@Test public void emptyNotScalar() {
		assertFalse(empty.isScalar());
	}
	
	@Test public void emptyIsVector() {
		assertTrue(empty.isVector());
	}
	
	@Test public void emptyNotMatrix() {
		assertFalse(empty.isMatrix());
	}
	
	@Test public void newIsCopy1() {
		AplArray test = new AplArray(matrix_empty.getShape());
		assertArrayEquals(test.getShape(), matrix_empty.getShape());
		assertNotSame(test.getShape(), matrix_empty.getShape());
	}

	@Test public void verifyIotaScalarRank() {
		assertEquals(1, iota_scalar_res.rank());
	}
	
	@Test public void verifyIotaShape() {
		int[] exp = {49};
		
		assertArrayEquals(exp, iota_scalar_res.getShape());
	}
	
	@Test public void verifyIotaScalarSize() {
		assertEquals(iota_scalar_in, iota_scalar_res.getSize());
	}
	
	@Test public void verifyIotaScalarValues() {
		for (int i = 0; i < iota_scalar_res.getSize(); i++) {
			assertEquals(i, iota_scalar_res.getInt(i));
		}
	}
	
	@Test public void verifyPlusShape() {
		int[] isrshp = iota_scalar_res.getShape();
		int[] pishp = plus_iota.getShape();
		
		assertArrayEquals(isrshp, pishp);
	}
	
	@Test public void verifyPlusSize() {
		assertEquals(iota_scalar_res.getSize(), plus_scalar.getSize());
	}
	
	@Test public void verifyPlusValues() {
		int exp;
		
		for (int i = 0; i < plus_iota.getSize(); i++) {
			exp = iota_scalar_res.getInt(i);
			exp += iota_scalar_res.getInt(i);
			
			assertEquals(exp, plus_iota.getInt(i));
		}
	}
	
	@Test public void verifyPlusScalarShape() {
		int[] shp = {49};
		
		assertArrayEquals(shp, plus_scalar.getShape());
	}
	
	@Test public void verifyPlusScalarRank() {
		assertEquals(1, plus_scalar.rank());
	}
	
	@Test public void verifyPlusScalarSize() {
		assertEquals(iota_scalar_in, plus_scalar.getSize());
	}
	
	@Test public void verifyPlusScalarValues() {
		for (int i = 0; i < plus_scalar.getSize(); i++) {
			int a = iota_scalar_res.getInt(i);
			int b = plus_scalar.getInt(i);
			
			assertEquals(7 + a, b);
		}
	}
		
	@Test public void newIsCopy2() {
		int[] shape = iota_scalar_res.getShape();
		int[] data = iota_scalar_res.getIntData();
		
		AplArray test = new AplArray(iota_scalar_res);
		
		assertNotSame(shape, test.getShape());
		assertArrayEquals(shape, test.getShape());
		
		assertNotSame(data, test.getIntData());
		assertArrayEquals(data, test.getIntData());
	}
	
	@Test public void verifyEachIdRank() {
		assertEquals(1, each_id.rank());
	}
	
	@Test public void verifyEachIdSize() {
		assertEquals(plus_scalar.getSize(), each_id.getSize());
	}
	
	@Test public void verifyEachIdShape() {
		assertArrayEquals(plus_scalar.getShape(), each_id.getShape());
	}
	
	@Test public void verifyEachIdNotCopy() {
		assertNotSame(plus_scalar.getShape(), each_id.getShape());
		assertNotSame(plus_scalar.getIntData(), each_id.getIntData());
	}
	
	@Test public void verifyEachIdValues() {
		assertArrayEquals(plus_scalar.getIntData(), each_id.getIntData());
	}
	
	@Test public void selfApplicationPlus() {
		AplArray arr = new AplArray(iota_scalar_res);
		AplArray exp = new AplArray();
		
		arr.plus(arr, arr);
		exp.plus(iota_scalar_res, iota_scalar_res);
		
		assertEquals(exp, arr);
	}
		

	@Test public void verifyEachScalarIdRank() {
		assertEquals(1, each_id_scalar.rank());
	}
	
	@Test public void verifyEachScalarIdSize() {
		assertEquals(plus_scalar.getSize(), each_id_scalar.getSize());
	}
	
	@Test public void verifyEachScalarIdShape() {
		assertArrayEquals(plus_scalar.getShape(), each_id_scalar.getShape());
	}
	
	@Test public void verifyEachScalarIdNotCopy() {
		assertNotSame(plus_scalar.getShape(), each_id_scalar.getShape());
		assertNotSame(plus_scalar.getIntData(), each_id_scalar.getIntData());
	}
	
	@Test public void verifyEachScalarIdValues() {
		assertArrayEquals(plus_scalar.getIntData(), each_id_scalar.getIntData());
	}
	
	@Test public void eachSelfReference() {
		AplArray test = new AplArray(plus_scalar);
		test.each(id_fun, test);
		assertEquals(plus_scalar, test);
	}
	
	@Test public void eachScalarSelfReference() {
		AplArray test = new AplArray(plus_scalar);
		test.each(id_fun_scalar, test);
		assertEquals(plus_scalar, test);
	}
	
	@Test public void testReduce() {
		int exp = 0;
		
		for (int i = 0; i < iota_scalar_in; i++) {
			exp += i;
		}
		
		assertEquals(exp, reduce_arr.getInt(0));
	}
	
	@Test public void testReduceIsScalar() {
		assertTrue(reduce_arr.isScalar());
	}
	
	@Test public void testReduceSelfReference() {
		AplArray tmp = new AplArray(iota_scalar_res);
		tmp.reduce(plus, tmp);
		assertEquals(reduce_arr, tmp);
	}
	
	@Test public void testReduceIota() {
		AplArray res = new AplArray();
		res.reduceIota(plus, iota_scalar_in);
		assertEquals(reduce_arr, res);
	}
	
	@Test public void testReduceIotaPrimitiv() {
		AplArray res = new AplArray();
		res.reduceIota((AplFunctionPrimitive) plus, iota_scalar_in);
		assertEquals(reduce_arr, res);
	}
}
