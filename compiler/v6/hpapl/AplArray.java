package hpapl;

import java.util.Arrays;

public class AplArray extends AplOperand {
	
	private enum AplType {
		INTEGER, LONG, DOUBLE, CHAR, UNSET;
	}

	public static final AplType INTEGER = AplType.INTEGER;
	public static final AplType CHAR = AplType.CHAR;
	public static final AplType LONG = AplType.LONG;
	public static final AplType DOUBLE = AplType.DOUBLE;
	public static final AplType UNSET = AplType.UNSET;
	
	private AplType type;
	
	private int[] shape;
	
	private int[] data_int;
	private long[] data_long;
	private double[] data_double;
	private char[] data_char;
	
	private void clearState() {
		type = UNSET;
		data_int = null;
		data_long = null;
		data_double = null;
		data_char = null;
	}
	
	public void verifyType(AplType type) {
		if (this.type != type) {
			throw new AplTypeException();
		}
	}
	
	public void verifyTypes(AplType... types) {
		boolean error = true;
		
		for (AplType t : types) {
			if (type == t) { 
				error = false;
				break;
			}
		}
			
		if (error) {
			throw new AplTypeException();
		}
	}
	
	public void initializeState(AplType type) {
		int size = 1;
		
		for (int e : shape) size *= e;
		
		this.type = type;
		switch(type) {
		case INTEGER: 
			if (data_int == null || data_int.length != size) {
				data_int = new int[size];
			}
			data_long = null;
			data_double = null;
			data_char = null;
			break;
		case LONG: 
			if (data_long == null || data_long.length != size) {
				data_long = new long[size]; break;
			}
			data_int = null;
			data_double = null;
			data_char = null;
			break;
		case DOUBLE:
			if (data_double == null || data_double.length != size) {
				data_double = new double[size]; break;
			}
			data_int = null;
			data_long = null;
			data_char = null;
			break;
		case CHAR: 
			if (data_char == null || data_char.length != size) {
				data_char = new char[size]; break;
			}
			data_int = null;
			data_long = null;
			data_double = null;
			break;
		default: throw new AplTypeException();
		}
	}
	
	private void ensureType(AplType type) {
		if (this.type == UNSET) {
			initializeState(type);
		} else {
			verifyType(type);
		}
	}
	
	public AplArray() {
		shape = new int[1];
		shape[0] = 0;
		clearState();
	}
	
	public AplArray(int rank) {
		shape = new int[rank];
		clearState();
	}
	
	public AplArray(int[] shape) {
		this.shape = new int[shape.length];
		System.arraycopy(shape, 0, this.shape, 0, shape.length);
		clearState();
	}
	
	public AplArray(int[] shape, int[] data) {
		this(shape);
		type = INTEGER;
		data_int = new int[data.length];
		System.arraycopy(data, 0, data_int, 0, data.length);
	}
	
	public AplArray(int[] shape, long[] data) {
		this(shape);
		type = LONG;
		data_long = new long[data.length];
		System.arraycopy(data, 0, data_int, 0, data.length);
	}
	
	public AplArray(int[] shape, double[] data) {
		this(shape);
		type = DOUBLE;
		data_double = new double[data.length];
		System.arraycopy(data, 0, data_int, 0, data.length);
	}
	
	public AplArray(int[] shape, char[] data) {
		this(shape);
		type = CHAR;
		data_char = new char[data.length];
		System.arraycopy(data, 0, data_int, 0, data.length);
	}
	
	public AplArray(AplArray arr) {
		this(arr.getShape());
		type = arr.getType();
		switch(type) {
		case INTEGER:
			data_int = new int[arr.getSize()];
			System.arraycopy(arr.getIntData(), 0, data_int, 0, data_int.length);
			break;
		case LONG:
			data_long = new long[arr.getSize()];
			System.arraycopy(arr.getLongData(), 0, data_long, 0, data_long.length);
			break;
		case DOUBLE:
			data_double = new double[arr.getSize()];
			System.arraycopy(arr.getDoubleData(), 0, data_double, 0, data_double.length);
			break;
		case CHAR:
			data_char = new char[arr.getSize()];
			System.arraycopy(arr.getCharData(), 0, data_char, 0, data_char.length);
			break;
		default:
		}
	}
	
	public AplType getType() {
		return type;
	}
	
	public int getSize() {
		switch(type) {
		case INTEGER: return data_int.length; 
		case LONG: return data_long.length;
		case DOUBLE: return data_double.length; 
		case CHAR: return data_char.length;
		default: return 0;
		}
	}
	
	public int[] getShape() {
		return shape;
	}
	
	public void setShape(int[] shp) {
		if (shape.length != shp.length) {
			shape = new int[shp.length];
		}
		
		System.arraycopy(shp, 0, shape, 0, shape.length);
	}		
	
	public int getInt(int idx) {
		verifyType(INTEGER);
		return data_int[idx];
	}
	
	public long getLong(int idx) {
		verifyType(LONG);
		return data_long[idx];
	}
		
	public double getDouble(int idx) {
		verifyType(DOUBLE);
		return data_double[idx];
	}
		
	public char getChar(int idx) {
		verifyType(CHAR);
		return data_char[idx];
	}
		
	public int[] getIntData() {
		verifyType(INTEGER);
		return data_int;
	}
	
	public long[] getLongData() {
		verifyType(LONG);
		return data_long;
	}
	
	public double[] getDoubleData() {
		verifyType(DOUBLE);
		return data_double;
	}
	
	public char[] getCharData() {
		verifyType(CHAR);
		return data_char;
	}
	
	public void set(int idx, int val) {
		ensureType(INTEGER);
		data_int[idx] = val;
	}
	
	public void set(int idx, long val) {
		ensureType(LONG);
		data_long[idx] = val;
	}
	
	public void set(int idx, double val) {
		ensureType(DOUBLE);
		data_double[idx] = val;
	}
	
	public void set(int idx, char val) {
		ensureType(CHAR);
		data_char[idx] = val;
	}
	
	public void setFrom(int idx, AplArray in, int inidx) {
		ensureType(in.getType());
		
		switch(type) {
		case INTEGER: set(idx, in.getInt(inidx)); break;
		case LONG: set(idx, in.getLong(inidx)); break;
		case DOUBLE: set(idx, in.getDouble(inidx)); break; 
		case CHAR: set(idx, in.getChar(inidx)); break; 
		default: throw new AplTypeException();
		}
	}
	
	public boolean isEmpty() {
		for (int e : shape) {
			if (0 == e) return true;
		}
		return false;
	}
	
	public int rank() {
		return shape.length;
	}
	
	public boolean isScalar() {
		return 0 == rank();
	}
	
	public boolean isVector() {
		return 1 == rank();
	}
	
	public boolean isMatrix() {
		return 2 == rank();
	}
	
	public void iota(int cnt) {
		int[] data = data_int;
		int[] shp = {cnt};
		
		setShape(shp);
		clearState();
		
		if (data != null && data.length == cnt) {
			data_int = data;
		} else {
			data_int = new int[cnt];
		}
		
		for (int i = 0; i < cnt; i++) {
			data_int[i] = i;
		}
		
		type = INTEGER;
	}
	
	public void iota(AplArray shp) {
		if (INTEGER != shp.getType()) {
			throw new AplDomainException();
		}
		
		if (shp.isVector()) {
			if (1 == shp.getSize()) {
				iota(shp.getInt(0));
			} else {
				throw new AplDomainException();
			}
		} else if (shp.isScalar()) {
			iota(shp.getInt(0));
		} else {
			throw new AplDomainException();
		}
	}
	
	public void each(AplFunction fun, AplArray rgt) {
		setShape(rgt.getShape());
		
		switch(rgt.getType()) {
		case INTEGER: each(fun, rgt.getIntData()); break;
		case LONG: each(fun, rgt.getLongData()); break;
		case DOUBLE: each(fun, rgt.getDoubleData()); break;
		case CHAR: each(fun, rgt.getCharData()); break;
		default: throw new AplTypeException();
		}
	}
			
	private void each(AplFunction fun, int[] rgtd) {
		AplArray in = new AplArray(0);
		AplArray out = new AplArray(0);
		
		clearState();
		
		for (int i = 0; i < rgtd.length; i++) {
			in.set(0, rgtd[i]);
			fun.apply(out, in);
			setFrom(i, out, 0);
		}
	}
	
	private void each(AplFunction fun, long[] rgtd) {
		AplArray in = new AplArray(0);
		AplArray out = new AplArray(0);
		
		clearState();
		
		for (int i = 0; i < rgtd.length; i++) {
			in.set(0, rgtd[i]);
			fun.apply(out, in);
			setFrom(i, out, 0);
		}
	}
	
	private void each(AplFunction fun, double[] rgtd) {
		AplArray in = new AplArray(0);
		AplArray out = new AplArray(0);
		
		clearState();
		
		for (int i = 0; i < rgtd.length; i++) {
			in.set(0, rgtd[i]);
			fun.apply(out, in);
			setFrom(i, out, 0);
		}
	}
	
	private void each(AplFunction fun, char[] rgtd) {
		AplArray in = new AplArray(0);
		AplArray out = new AplArray(0);
		
		clearState();
		
		for (int i = 0; i < rgtd.length; i++) {
			in.set(0, rgtd[i]);
			fun.apply(out, in);
			setFrom(i, out, 0);
		}
	}
	
	public void each(AplFunctionScalar fun, AplArray rgt) {
		fun.apply(this, rgt);
	}
	
	public void each(AplFunctionScalar fun, AplArray lft, AplArray rgt) {
		fun.apply(this, lft, rgt);
	}
	
	public boolean sameShape(AplArray arr) {
		return Arrays.equals(shape, arr.getShape());
	}
	
	public void copy(AplArray arr) {
		if (this == arr) return;
		
		setShape(arr.getShape());
		clearState();
		ensureType(arr.getType());
		
		switch(arr.getType()) {
		case INTEGER:
			System.arraycopy(arr.getIntData(), 0, data_int, 0, getSize());
			break;
		case LONG:
			System.arraycopy(arr.getLongData(), 0, data_long, 0, getSize());
			break;
		case DOUBLE:
			System.arraycopy(arr.getDoubleData(), 0, data_double, 0, getSize());
			break;
		case CHAR:
			System.arraycopy(arr.getCharData(), 0, data_char, 0, getSize());
			break;
		default: throw new AplTypeException();
		}
	}
	
	private void verifyAndSetScalarShapes(AplArray lft, AplArray rgt) {
		if (lft.sameShape(rgt)) {
			setShape(lft.getShape());
		} else if (lft.isScalar()) {
			setShape(rgt.getShape());
		} else if (rgt.isScalar()) {
			setShape(lft.getShape());
		} else {
			throw new AplShapeMismatchException(lft, rgt);
		}
	}
	
	private void plus(int[] ld, int[] rd) {
		initializeState(INTEGER);
		for (int i = 0; i < data_int.length; i++) {
			data_int[i] = ld[i] + rd[i];
		}
	} 
	
	private void plus(int[] ld, long[] rd) {
		initializeState(LONG);
		for (int i = 0; i < data_int.length; i++) {
			data_long[i] = ld[i] + rd[i];
		}
	} 

	private void plus(int[] ld, double[] rd) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = ld[i] + rd[i];
		}
	} 

	private void plus(long[] ld, int[] rd) {
		initializeState(LONG);
		for (int i = 0; i < data_int.length; i++) {
			data_long[i] = ld[i] + rd[i];
		}
	} 

	private void plus(long[] ld, long[] rd) {
		initializeState(LONG);
		for (int i = 0; i < data_int.length; i++) {
			data_long[i] = ld[i] + rd[i];
		}
	} 

	private void plus(long[] ld, double[] rd) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = ld[i] + rd[i];
		}
	} 

	private void plus(double[] ld, int[] rd) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = ld[i] + rd[i];
		}
	} 

	private void plus(double[] ld, long[] rd) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = ld[i] + rd[i];
		}
	} 
	
	private void plus(double[] ld, double[] rd) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = ld[i] + rd[i];
		}
	} 
	
	private void plus_scalar(int s, int[] a) {
		initializeState(INTEGER);
		for (int i = 0; i < data_int.length; i++) {
			data_int[i] = s + a[i];
		}
	}
	
	private void plus_scalar(int s, long[] a) {
		initializeState(LONG);
		for (int i = 0; i < data_int.length; i++) {
			data_long[i] = s + a[i];
		}
	}
	
	private void plus_scalar(int s, double[] a) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = s + a[i];
		}
	}
	
	private void plus_scalar(long s, int[] a) {
		initializeState(LONG);
		for (int i = 0; i < data_int.length; i++) {
			data_long[i] = s + a[i];
		}
	}
	
	private void plus_scalar(long s, long[] a) {
		initializeState(LONG);
		for (int i = 0; i < data_int.length; i++) {
			data_long[i] = s + a[i];
		}
	}
	
	private void plus_scalar(long s, double[] a) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = s + a[i];
		}
	}
	
	private void plus_scalar(double s, int[] a) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = s + a[i];
		}
	}
	
	private void plus_scalar(double s, long[] a) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = s + a[i];
		}
	}
	
	private void plus_scalar(double s, double[] a) {
		initializeState(DOUBLE);
		for (int i = 0; i < data_int.length; i++) {
			data_double[i] = s + a[i];
		}
	}
	
	public void plus(AplArray lft, AplArray rgt) {
		boolean scalar = false;
		
		verifyAndSetScalarShapes(lft, rgt);
		
		if (lft.isScalar()) { 
			scalar = true;
		} else if (rgt.isScalar()) {
			scalar = true;
			AplArray tmp = rgt;
			rgt = lft;
			lft = rgt;
		}
		
		switch (lft.getType()) {
		case INTEGER:
			switch (rgt.getType()) {
			case INTEGER: 
				if (scalar) 
					plus_scalar(lft.getInt(0), rgt.getIntData());
				else 
					plus(lft.getIntData(), rgt.getIntData());
				break;
			case LONG:
				if (scalar) 
					plus_scalar(lft.getInt(0), rgt.getLongData());
				else 
					plus(lft.getIntData(), rgt.getLongData());
				break;
			case DOUBLE:
				if (scalar) 
					plus_scalar(lft.getInt(0), rgt.getDoubleData());
				else 
					plus(lft.getIntData(), rgt.getDoubleData());
				break;
			default: throw new AplDomainException();
			}
			break;
		case LONG:
			switch(rgt.getType()) {
			case INTEGER: 
				if (scalar) 
					plus_scalar(lft.getLong(0), rgt.getIntData());
				else 
					plus(lft.getLongData(), rgt.getIntData());
				break;
			case LONG:
				if (scalar) 
					plus_scalar(lft.getLong(0), rgt.getLongData());
				else 
					plus(lft.getLongData(), rgt.getLongData());
				break;
			case DOUBLE:
				if (scalar) 
					plus_scalar(lft.getLong(0), rgt.getDoubleData());
				else 
					plus(lft.getLongData(), rgt.getDoubleData());
				break;
			default: throw new AplDomainException();
			}
			break;
		case DOUBLE:
			switch(rgt.getType()) {
			case INTEGER:
				if (scalar) 
					plus_scalar(lft.getDouble(0), rgt.getIntData());
				else 
					plus(lft.getDoubleData(), rgt.getIntData());
				break;
			case LONG:
				if (scalar) 
					plus_scalar(lft.getDouble(0), rgt.getLongData());
				else 
					plus(lft.getDoubleData(), rgt.getLongData());
				break;
			case DOUBLE:
				if (scalar) 
					plus_scalar(lft.getDouble(0), rgt.getDoubleData());
				else 
					plus(lft.getDoubleData(), rgt.getDoubleData());
				break;
			default: throw new AplDomainException();
			}
			break;
		default: throw new AplDomainException();
		}
	}
	
	public void plus(AplArray arr) {
		throw new AplNonceException();	
	}
	
	public static class PlusFunction extends AplFunctionScalar {
		public void apply(AplArray out, AplArray lft, AplArray rgt) {
			out.plus(lft, rgt);
		}
		public void apply(AplArray out, AplArray rgt) {
			throw new AplNonceException();
		}		
	}
	
	public void print() {
		switch(type) {
		case INTEGER: 
			for (int e : data_int) {
				System.out.print(e);
				System.out.print(" ");
			}
			break;
		case LONG:
			for (long e : data_long) {
				System.out.print(e);
				System.out.print(" ");
			}
			break;
		case DOUBLE:
			for (double e : data_double) {
				System.out.print(e);
				System.out.print(" ");
			}
			break;
		case CHAR: 
			for (char e : data_char) {
				System.out.print(e);
				System.out.print(" ");
			}
			break;
		default:
		}
		System.out.println("");
	}
	
	public boolean equals(Object obj) {
		if (!(obj instanceof AplArray)) return false;
		
		AplArray arr = (AplArray) obj;
		
		if (!sameShape(arr)) return false;
		if (type != arr.getType()) return false;
		
		switch (type) {
		case INTEGER:
			if (!Arrays.equals(data_int, arr.getIntData())) return false;
			break;
		case LONG:
			if (!Arrays.equals(data_long, arr.getLongData())) return false;
			break;
		case DOUBLE:
			if (!Arrays.equals(data_double, arr.getDoubleData())) return false;
			break;
		case CHAR:
			if (!Arrays.equals(data_char, arr.getCharData())) return false;
			break;
		default:
		}
		return true;
	}
	
	public void reduce(AplFunction fun, AplArray arr) {
		if (!arr.isVector()) {
			throw new AplNonceException();
		} else {
			int[] shp = {};
			
			setShape(shp);
			
			switch (arr.getType()) {
			case INTEGER: reduce(fun, arr.getIntData()); break;
			case LONG: reduce(fun, arr.getLongData()); break;
			case DOUBLE: reduce(fun, arr.getDoubleData()); break;
			case CHAR: reduce(fun, arr.getCharData()); break;
			default: throw new AplTypeException();
			}
		}
	}
	
	public void reduce(AplFunction fun, int[] data) {
		AplArray in = new AplArray(0);
		
		clearState();
		
		if (0 == data.length) {
			set(0, 0);
			return;
		} else {
			set(0, data[data.length - 1]);
		}
		
		for (int i = data.length - 2; i >= 0; i--) {
			in.set(0, data[i]);
			fun.apply(this, in, this);
		}
	}
	
	public void reduce(AplFunction fun, long[] data) {
		AplArray in = new AplArray(0);
		
		clearState();
		
		if (0 == data.length) {
			set(0, 0);
			return;
		} else {
			set(0, data[data.length - 1]);
		}
		
		for (int i = data.length - 2; i >= 0; i--) {
			in.set(0, data[i]);
			fun.apply(this, in, this);
		}
	}
	
	public void reduce(AplFunction fun, double[] data) {
		AplArray in = new AplArray(0);
		
		clearState();
		
		if (0 == data.length) {
			set(0, 0);
			return;
		} else {
			set(0, data[data.length - 1]);
		}
		
		for (int i = data.length - 2; i >= 0; i--) {
			in.set(0, data[i]);
			fun.apply(this, in, this);
		}
	}
	
	public void reduce(AplFunction fun, char[] data) {
		AplArray in = new AplArray(0);
		
		clearState();
		
		if (0 == data.length) {
			set(0, ' ');
			return;
		} else {
			set(0, data[data.length - 1]);
		}
		
		for (int i = data.length - 2; i >= 0; i--) {
			in.set(0, data[i]);
			fun.apply(this, in, this);
		}
	}
			
}
