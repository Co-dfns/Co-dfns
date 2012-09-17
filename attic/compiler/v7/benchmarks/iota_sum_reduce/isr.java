public class isr {
	
	private static int compute(int rgt) {
		int sum = 1;
		
		for (int i = 0; i < rgt; i++) sum += i;
		
		return sum;
	}
	
	public static void main(String[] args) {
		int count = 100000;
		int[] res = new int[count];
		
		for (int i = 0; i < count; i++) res[i] = compute(i);
		
		System.out.println(res[count - 1]);
	}
	
}
