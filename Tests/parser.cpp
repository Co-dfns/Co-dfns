#include "stdafx.h"
#include "CppUnitTest.h"

#include <boost/variant.hpp>

#include "ast.h"
#include "Parser.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

using boost::get;

namespace Tests
{		
	TEST_CLASS(TestParser)
	{
	public:
		
		TEST_METHOD(ParseInteger1)
		{
			Parser p(L"V←0");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(0L);
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseInteger2)
		{
			Parser p(L"V←123");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(123L);
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseFloating1)
		{
			Parser p(L"V←0.0");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(0.0);
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseFloating2)
		{
			Parser p(L"V←1.0");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(1.0);
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseFloating3)
		{
			Parser p(L"V←¯1.23");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(-1.23);
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseNeg1)
		{
			Parser p(L"V←¯132");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(-132L);
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseNeg2)
		{
			Parser p(L"V←¯0");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(-0L);
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseChar1)
		{
			Parser p(L"V←'a'");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(L"a");
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseChar2)
		{
			Parser p(L"V←'⍴'");
			Module exp = p.parse();

			Variable v(L"V");
			Literal lit(L"⍴");
			VarAssignment a(v, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseIntArray)
		{
			Parser p(L"V←1 2 3");
			Module exp = p.parse();
			std::vector<Value> v;

			v.push_back(1L);
			v.push_back(2L);
			v.push_back(3L);

			Variable var(L"V");
			Literal lit(v);
			VarAssignment a(var, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseFloatArray)
		{
			Parser p(L"V←1.0 2.0 3.0");
			Module exp = p.parse();
			std::vector<Value> vec;

			vec.push_back(1.0);
			vec.push_back(2.0);
			vec.push_back(3.0);

			Variable var(L"V");
			Literal lit(vec);
			VarAssignment a(var, lit);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseNilFunction)
		{
			Parser p(L"F←{}");
			Module exp = p.parse();
			FnDef f;
			Variable var(L"F");
			FnAssignment a(var, f);
			Module res(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseStr1)
		{
			Parser p(L"V←'abcdk8923⌈⌊_'");
			Module res = p.parse();
			Variable var(L"V");
			Literal val(L"abcdk8923⌈⌊_");
			VarAssignment a(var, val);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseMixed1)
		{
			Parser p(L"V←2.0 1.0 ¯1");
			Module res = p.parse();
			Variable var(L"V");
			std::vector<Value> v;

			v.push_back(2.0);
			v.push_back(1.0);
			v.push_back(-1L);

			Literal lit(v);
			VarAssignment a(var, lit);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseNeg3)
		{
			Parser p(L"V←¯1 ¯1 ¯1");
			Module res = p.parse();
			Variable var(L"V");
			std::vector<Value> v;

			v.push_back(-1L);
			v.push_back(-1L);
			v.push_back(-1L);

			Literal lit(v);
			VarAssignment a(var, lit);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseEmptyArray)
		{
			Parser p(L"V←⍬");
			Module res = p.parse();
			Variable var(L"V");

			Literal lit;
			VarAssignment a(var, lit);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseMixedArray1)
		{
			Parser p(L"V←23 23 3.0 'aklds' 23 'a'");
			Module res = p.parse();
			Variable var(L"V");
			std::vector<Value> v;

			v.push_back(23L);
			v.push_back(23L);
			v.push_back(3.0);
			v.push_back(L"aklds");
			v.push_back(23L);
			v.push_back(L"a");

			Literal lit(v);
			VarAssignment a(var, lit);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseVariableAssignment1)
		{
			Parser p(L"V←X");
			Module res = p.parse();
			Variable var(L"V");
			Variable v(L"X");

			VarAssignment a(var, v);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseVariableAssignment2)
		{
			Parser p(L"V←adjks");
			Module res = p.parse();
			Variable var(L"V");
			Variable v(L"adjks");

			VarAssignment a(var, v);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseVariableAssignment3)
		{
			Parser p(L"V←ksd_hdklsd");
			Module res = p.parse();
			Variable var(L"V");
			Variable v(L"ksd_hdklsd");

			VarAssignment a(var, v);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseApplication1)
		{
			Parser p(L"V←5+5");
			Module res = p.parse();
			Variable var(L"V");
			Literal five(5L);
			DyadicApp v(five, PRIM_FN_PLUS, five);
			VarAssignment a(var, v);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseApplication2)
		{
			Parser p(L"V←! 5 2 3");
			Module res = p.parse();
			Variable var(L"V");
			std::vector<Value> vals;
			
			vals.push_back(5L);
			vals.push_back(2L);
			vals.push_back(3L);

			Literal lit(vals);
			MonadicApp v(PRIM_FN_BANG, lit);
			VarAssignment a(var, v);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseApplication3)
		{
			Parser p(L"V←2893 82!8929 23");
			Module res = p.parse();
			Variable var(L"V");
			std::vector<Value> rgt;
			std::vector<Value> lft;

			rgt.push_back(8929L);
			rgt.push_back(23L);
			lft.push_back(2893L);
			lft.push_back(82L);

			Literal litr(rgt);
			Literal litl(lft);
			DyadicApp v(litl, PRIM_FN_BANG, litr);
			VarAssignment a(var, v);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp1)
		{
			Parser p(L"V←5×5+289");
			Module res = p.parse();

			Literal litfive(5L);
			Literal lithund(289L);
			DyadicApp app1(litfive, PRIM_FN_PLUS, lithund);
			DyadicApp app2(litfive, PRIM_FN_TIMES, app1);
			Variable v(L"V");
			VarAssignment a(v, app2);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp2)
		{
			Parser p(L"V←(289 289+3)÷4");
			Module res = p.parse();
			std::vector<Value> hund;

			hund.push_back(289L);
			hund.push_back(289L);

			Literal lithund(hund);
			Literal litthree(3L);
			Literal litfour(4L);
			DyadicApp app1(lithund, PRIM_FN_PLUS, litthree);
			DyadicApp app2(app1, PRIM_FN_DIVIDE, litfour);
			Variable v(L"V");
			VarAssignment a(v, app2);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp3)
		{
			Parser p(L"V←2839⍴28");
			Module res = p.parse();

			Literal litav(2839L);
			Literal litbv(28L);
			DyadicApp app1(litav, PRIM_FN_RHO, litbv);
			Variable v(L"V");
			VarAssignment a(v, app1);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp4)
		{
			Parser p(L"V←X+X");
			Module res = p.parse();

			Variable x(L"X");
			DyadicApp app1(x, PRIM_FN_PLUS, x);
			Variable v(L"V");
			VarAssignment a(v, app1);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp5)
		{
			Parser p(L"V←5+X");
			Module res = p.parse();

			Variable x(L"X");
			Literal litfive(5L);
			DyadicApp app1(litfive, PRIM_FN_PLUS, x);
			Variable v(L"V");
			VarAssignment a(v, app1);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp6)
		{
			Parser p(L"V←X+5");
			Module res = p.parse();
			Variable x(L"X");
			Literal litfive(5L);
			DyadicApp app1(x, PRIM_FN_PLUS, litfive);
			Variable v(L"V");
			VarAssignment a(v, app1);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp7)
		{
			Parser p(L"V←5 5+X");
			Module res = p.parse();
			std::vector<Value> five;

			five.push_back(5L);
			five.push_back(5L);

			Variable x(L"X");
			Literal litfive(five);
			DyadicApp app1(litfive, PRIM_FN_PLUS, x);
			Variable v(L"V");
			VarAssignment a(v, app1);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp8)
		{
			Parser p(L"V←(X)+5");
			Module res = p.parse();
			Variable x(L"X");
			Literal litfive(5L);
			DyadicApp app1(x, PRIM_FN_PLUS, litfive);
			Variable v(L"V");
			VarAssignment a(v, app1);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp9)
		{
			Parser p(L"X Y←5");
			Module res = p.parse();
			Variable x(L"X");
			Variable y(L"Y");
			std::vector<VariableStrand> vars;

			vars.push_back(x);
			vars.push_back(y);

			Literal litfive(5L);
			StrandAssignment a(vars, litfive);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseExp10)
		{
			Parser p(L"X Y←⊂'abkd'");
			Module res = p.parse();
			std::wstring s = L"abkd";

			Literal lits(s);
			MonadicApp app(PRIM_FN_ENCLOSE, lits);

			Variable x(L"X");
			Variable y(L"Y");
			std::vector<VariableStrand> vars;

			vars.push_back(x);
			vars.push_back(y);

			StrandAssignment a(vars, app);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseExp11)
		{
			Parser p(L"(X (Y Z))←A");
			Module res = p.parse();
			
			Variable z(L"Z");
			Variable x(L"X");
			Variable y(L"Y");
			std::vector<VariableStrand> inner;
			std::vector<VariableStrand> vars;

			inner.push_back(y);
			inner.push_back(z);
			vars.push_back(x);
			vars.push_back(inner);

			Variable va(L"A");
			StrandAssignment a(vars, va);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseExp12)
		{
			Parser p(L"V←5+(X←5)×3");
			Module res = p.parse();
			
			Variable v(L"V");
			Variable x(L"X");
			Literal five(5L);
			Literal three(3L);
			VarAssignment xa(x, five);
			DyadicApp app1(xa, PRIM_FN_TIMES, three);
			DyadicApp app2(five, PRIM_FN_PLUS, app1);
			VarAssignment va(v, app2);
			Module exp(std::vector<Assignment>(1, va));
			
			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStmt1)
		{
			Parser p(L"F←{5 ⋄ 4}");
			Module res = p.parse();

			Literal five(5L);
			Literal four(4L);
			std::vector<Statement> fnb;

			fnb.push_back(five);
			fnb.push_back(four);

			FnDef fn(fnb);
			Variable f(L"F");
			FnAssignment a(f, fn);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseStmt2)
		{
			Parser p(L"F←{X←5 ⋄ X+X}");
			Module res = p.parse();

			Variable x(L"X");
			std::vector<Statement> fnb;

			fnb.push_back(VarAssignment(x, Literal(5L)));
			fnb.push_back(DyadicApp(x, PRIM_FN_PLUS, x));

			FnDef fn(fnb);
			Variable f(L"F");
			FnAssignment a(f, fn);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStmt3)
		{
			Parser p(L"F←{X Y←5 ⋄ Z←3 ⋄ X+Y+Z}");
			Module res = p.parse();

			Variable x(L"X");
			Variable y(L"Y");
			Variable z(L"Z");
			std::vector<VariableStrand> xy;
			std::vector<Statement> fnb;
			DyadicApp YpZ(y, PRIM_FN_PLUS, z);

			xy.push_back(x);
			xy.push_back(y);
			fnb.push_back(StrandAssignment(xy, Literal(5L)));
			fnb.push_back(VarAssignment(z, Literal(3L)));
			fnb.push_back(DyadicApp(x, PRIM_FN_PLUS, YpZ));

			FnDef fn(fnb);
			Variable f(L"F");
			FnAssignment a(f, fn);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStmt4)
		{
			Parser p(L"F←{0:5}");
			Module res = p.parse();

			CondStatement stmt(Literal(0L), Literal(5L));
			std::vector<Statement> fnb(1, stmt);
			FnAssignment a(Variable(L"F"), FnDef(fnb));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStmt5)
		{
			Parser p(L"F←{1:5}");
			Module res = p.parse();

			CondStatement stmt(Literal(1L), Literal(5L));
			std::vector<Statement> fnb(1, stmt);
			FnAssignment a(Variable(L"F"), FnDef(fnb));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStmt6)
		{
			Parser p(L"F←{(52=42):X+5 ⋄ X←23 ⋄ X=23:X}");
			Module res = p.parse();

			Variable x(L"X");
			DyadicApp t1(Literal(52L), PRIM_FN_EQUAL, Literal(42L));
			DyadicApp c1(x, PRIM_FN_PLUS, Literal(5L));
			CondStatement s1(t1, c1);
			VarAssignment s2(x, Literal(23L));
			DyadicApp t2(x, PRIM_FN_EQUAL, Literal(23L));
			CondStatement s3(t2, x);
			std::vector<Statement> fnb;

			fnb.push_back(s1);
			fnb.push_back(s2);
			fnb.push_back(s3);

			FnAssignment a(Variable(L"F"), FnDef(fnb));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseFormals1)
		{
			Parser p(L"V←5 {⍺+⍵} 3");
			Module res = p.parse();

			DyadicApp e(Variable(L"⍺"), PRIM_FN_PLUS, Variable(L"⍵"));
			FnDef fn(std::vector<Statement>(1, e));
			DyadicApp app(Literal(5L), fn, Literal(3L));
			VarAssignment a(Variable(L"V"), app);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseFormals2)
		{
			Parser p(L"V←3 2 3{⍺,⍵}3 2");
			Module res = p.parse();

			DyadicApp e(Variable(L"⍺"), PRIM_FN_COMMA, Variable(L"⍵"));
			FnDef fn(std::vector<Statement>(1, e));
			std::vector<Value> lftv;
			std::vector<Value> rgtv;

			lftv.push_back(3L);
			lftv.push_back(2L);
			lftv.push_back(3L);
			rgtv.push_back(3L);
			rgtv.push_back(2L);

			DyadicApp app(Literal(lftv), fn, Literal(rgtv));
			VarAssignment a(Variable(L"V"), app);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseFormals3)
		{
			Parser p(L"V←{} X");
			Module res = p.parse();

			MonadicApp app(FnDef(), Variable(L"X"));
			VarAssignment a(Variable(L"V"), app);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseFormals4)
		{
			Parser p(L"V←{⍵} X");
			Module res = p.parse();

			FnDef fn(std::vector<Statement>(1, Variable(L"⍵")));
			MonadicApp app(fn, Variable(L"X"));
			VarAssignment a(Variable(L"V"), app);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseFormals5)
		{
			Parser p(L"F←{⍺+⍵}");
			Module res = p.parse();

			DyadicApp app(Variable(L"⍺"), PRIM_FN_PLUS, Variable(L"⍵"));
			FnDef fn(std::vector<Statement>(1, app));
			FnAssignment a(Variable(L"F"), fn);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseMultiDefs1)
		{
			Parser p(L"F←{} ⋄ V←32");
			Module res = p.parse();

			std::vector<Assignment> defs;

			defs.push_back(FnAssignment(Variable(L"F"), FnDef()));
			defs.push_back(VarAssignment(Variable(L"V"), Literal(32L)));
			Module exp(defs);

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseMultiDefs2)
		{
			Parser p(L"F←{⍺+⍵} ⋄ V←52 33");
			Module res = p.parse();

			std::vector<Assignment> defs;
			std::vector<Value> vals;
			DyadicApp app(Variable(L"⍺"), PRIM_FN_PLUS, Variable(L"⍵"));
			std::vector<Statement> fnb(1, app);

			vals.push_back(52L);
			vals.push_back(33L);
			defs.push_back(FnAssignment(Variable(L"F"), FnDef(fnb)));
			defs.push_back(VarAssignment(Variable(L"V"), Literal(vals)));
			Module exp(defs);

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseMultiDefs3)
		{
			Parser p(L"F←{X←3 ⋄ F←{!⍵} ⋄ X}");
			Module res = p.parse();

			VarAssignment s1(Variable(L"X"), Literal(3L));
			MonadicApp app(PRIM_FN_BANG, Variable(L"⍵"));
			FnDef fn(std::vector<Statement>(1, app));
			Variable f(L"F");
			FnAssignment s2(f, fn);
			Variable s3(L"X");
			std::vector<Statement> fnb;
			
			fnb.push_back(s1);
			fnb.push_back(s2);
			fnb.push_back(s3);

			FnAssignment a(f, FnDef(fnb));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers1)
		{
			Parser p(L"V←52∘.+52");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers2)
		{
			Parser p(L"V←+∘× 3 2");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers3)
		{
			Parser p(L"V←7 +.× 5");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers4)
		{
			Parser p(L"V←÷⍨ 3 2");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers5)
		{
			Parser p(L"V←+¨3 4⍴⊂5 3");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers6)
		{
			Parser p(L"V←(?5⍴5)+¨5⍴5");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers7)
		{
			Parser p(L"V←+/⍳10");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers8)
		{
			Parser p(L"V←{(+/⍵)÷⊃⍴⍵} ⍳50");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers9)
		{
			Parser p(L"V←53 {⍺+⍵}.{⍺×⍵} 53");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers10)
		{
			Parser p(L"X←5∘⍳");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers11)
		{
			Parser p(L"X←5∘⍳∘⊂");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers12)
		{
			Parser p(L"X←5∘⍳5");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseMultiLine1)
		{
			std::wstring code = 
				L"F←{\n"
				L"	X←5\n"
				L"	Y←6\n"
				L"	X+Y\n"
				L"}\n";

			Parser p(code);
			Module res = p.parse();

			Variable x(L"X");
			Variable y(L"Y");
			std::vector<Statement> fnb;

			fnb.push_back(VarAssignment(x, Literal(5L)));
			fnb.push_back(VarAssignment(y, Literal(6L)));
			fnb.push_back(DyadicApp(x, PRIM_FN_PLUS, y));

			FnAssignment a(Variable(L"F"), FnDef(fnb));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseMultiLine2)
		{
			std::wstring code = 
				L"F←{\n"
				L"	X←5\n\n"
				L"	Y←6\n\n"
				L"	X+Y\n\n"
				L"}\n";

			Parser p(code);
			Module res = p.parse();

			Variable x(L"X");
			Variable y(L"Y");
			std::vector<Statement> fnb;

			fnb.push_back(VarAssignment(x, Literal(5L)));
			fnb.push_back(VarAssignment(y, Literal(6L)));
			fnb.push_back(DyadicApp(x, PRIM_FN_PLUS, y));

			FnAssignment a(Variable(L"F"), FnDef(fnb));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseMultiLine3)
		{
			std::wstring code = 
				L"F←{\n"
				L"	X←5\n\n"
				L"	Y←7\n\n"
				L"	X,Y\n"
				L"}\n\n"
				L"V←F ⍬\n";

			Parser p(code);
			Module res = p.parse();

			Variable x(L"X");
			Variable y(L"Y");
			std::vector<Statement> fnb;

			fnb.push_back(VarAssignment(x, Literal(5L)));
			fnb.push_back(VarAssignment(y, Literal(7L)));
			fnb.push_back(DyadicApp(x, PRIM_FN_COMMA, y));

			FnAssignment s1(Variable(L"F"), FnDef(fnb));
			MonadicApp a(Variable(L"F"), Literal());
			VarAssignment s2(Variable(L"V"), a);
			std::vector<Assignment> defs;

			defs.push_back(s1);
			defs.push_back(s2);

			Module exp(defs);

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseIndexing1)
		{
			Parser p(L"X←V[5]");
			Module res = p.parse();

			IndexRef e(Variable(L"V"), std::vector<IndexExpression>(1, Literal(5L)));
			VarAssignment a(Variable(L"X"), e);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseIndexing2)
		{
			Parser p(L"X←(⍳5)[3]");
			Module res = p.parse();

			MonadicApp app(PRIM_FN_IOTA, Literal(5L));
			IndexRef e(app, std::vector<IndexExpression>(1, Literal(3L)));
			VarAssignment a(Variable(L"X"), e);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseIndexing3)
		{
			Parser p(L"X←V[5;4]");
			Module res = p.parse();

			std::vector<IndexExpression> ind;

			ind.push_back(Literal(5L));
			ind.push_back(Literal(4L));

			IndexRef e(Variable(L"V"), ind);
			VarAssignment a(Variable(L"X"), e);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseIndexing4)
		{
			Parser p(L"X←V [ 5 ; 4 ]");
			Module res = p.parse();

			std::vector<IndexExpression> ind;

			ind.push_back(Literal(5L));
			ind.push_back(Literal(4L));

			IndexRef e(Variable(L"V"), ind);
			VarAssignment a(Variable(L"X"), e);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseBig1)
		{
			std::wstring code =
				L"box←{\n";
				L"	vrt hrz←(¯1+⍴⍵)⍴¨(⊂vt),⊂hz\n"
				L"	top←(hz,'⊖→')[¯1↑⍺],hrz\n"
				L"	bot←(⊃⍺),hrz\n"
				L"	rgt←tr,vt,vrt,br\n"
				L"	lax←(vt,'⌽↓')[¯1↓1↓⍺],¨⊂vrt\n"
				L"	lft←⍉tl,(↑lax),bl\n"
				L"	lft,(top⍪⍵⍪bot),rgt\n"
				L"}\n";

			Parser p(code);
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseIndexing5)
		{
			Parser p(L"V←X[]");
			Module res = p.parse();

			std::vector<IndexExpression> i(1, EmptyIndex());
			IndexRef e(Variable(L"X"), i);
			VarAssignment a(Variable(L"V"), e);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseIndexing6)
		{
			Parser p(L"V←X[5 2 3][1]");
			Module res = p.parse();

			std::vector<Value> fivetwothree;
			std::vector<IndexExpression> i1;
			std::vector<IndexExpression> i2;

			fivetwothree.push_back(5L);
			fivetwothree.push_back(2L);
			fivetwothree.push_back(3L);
			i1.push_back(Literal(fivetwothree));
			i2.push_back(Literal(1L));

			IndexRef e1(Variable(L"X"), i1);
			IndexRef e2(e1, i2);
			VarAssignment a(Variable(L"V"), e2);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers13)
		{
			Parser p(L"V←5 (!⍣5) 5");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseOpers14)
		{
			Parser p(L"X←!⍣5");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseUserOps1)
		{
			Parser p(L"F←{⍺⍺,⍵}");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseUserOps2)
		{
			Parser p(L"F←{⍺⍺ ⍵}");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseUserOps3)
		{
			Parser p(L"F← + {⍺⍺,⍵}");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseUserOps4)
		{
			Parser p(L"V←6 + {⍺ ⍺⍺ ⍵} 7");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStrand1)
		{
			Parser p(L"V←(5 (4 3))");
			Module res = p.parse();

			std::vector<Value> v1;
			std::vector<Value> v2;

			v1.push_back(4L);
			v1.push_back(3L);
			v2.push_back(5L);
			v2.push_back(v1);

			VarAssignment a(Variable(L"V"), Literal(v2));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStrand2)
		{
			Parser p(L"V←(5 (4 3) 2)");
			Module res = p.parse();

			std::vector<Value> v1;
			std::vector<Value> v2;

			v1.push_back(4L);
			v1.push_back(3L);
			v2.push_back(5L);
			v2.push_back(v1);
			v2.push_back(2L);

			VarAssignment a(Variable(L"V"), Literal(v2));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStrand3)
		{
			Parser p(L"V←5 (4 3) 2");
			Module res = p.parse();

			std::vector<Value> v1;
			std::vector<Value> v2;

			v1.push_back(4L);
			v1.push_back(3L);
			v2.push_back(5L);
			v2.push_back(v1);
			v2.push_back(2L);

			VarAssignment a(Variable(L"V"), Literal(v2));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStrand4)
		{
			Parser p(L"X Y←5");
			Module res = p.parse();

			Variable x(L"X");
			Variable y(L"Y");
			std::vector<VariableStrand> vars;

			vars.push_back(x);
			vars.push_back(y);

			Literal litfive(5L);
			StrandAssignment a(vars, litfive);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStrand5)
		{
			Parser p(L"X (Y Z)←5 4");
			Module res = p.parse();

			std::vector<VariableStrand> v1;
			std::vector<VariableStrand> v2;
			std::vector<Value> vals;

			v1.push_back(Variable(L"Y"));
			v1.push_back(Variable(L"Z"));
			v2.push_back(Variable(L"X"));
			v2.push_back(v1);
			vals.push_back(5L);
			vals.push_back(4L);

			StrandAssignment a(v2, Literal(vals));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStrand6)
		{
			Parser p(L"V←5 4 V X 8 2");
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseComments1)
		{
			std::wstring code =
				L"⍝ A Simple Factorial Example\n"
				L"fact←{ ⍝ We call the function fact\n"
				L"	0=⍵: 1\n\n"
				L"	⍝ Line with a comment on it.\n"
				L"	⍵ × ∇ ⍵-1\n"
				L"}\n\n"
				L"⍝ V←fact 5\n";
			Parser p(code);
			Module res = p.parse();

			std::vector<Statement> fnb;
			DyadicApp t1(Literal(0L), PRIM_FN_EQUAL, Variable(L"⍵"));
			CondStatement s1(t1, Literal(1L));
			DyadicApp sub(Variable(L"⍵"), PRIM_FN_MINUS, Literal(1L));
			MonadicApp rec(PRIM_FN_NABLA, sub);
			DyadicApp times(Variable(L"⍵"), PRIM_FN_TIMES, rec);

			fnb.push_back(s1);
			fnb.push_back(times);

			FnAssignment a(Variable(L"fact"), FnDef(fnb));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseMultiLine4)
		{
			std::wstring code =
				L"F←{ X←5 ⋄\n"
				L"	X\n"
				L"}\n\n";

			Parser p(code);
			Module res = p.parse();

			Variable x(L"X");
			std::vector<Statement> fnb;

			fnb.push_back(VarAssignment(x, Literal(5L)));
			fnb.push_back(x);

			FnAssignment a(Variable(L"F"), fnb);
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseStmt7)
		{
			Parser p(L"F←{ X←5 ⋄ ⋄ X}");
			Module res = p.parse();

			Variable x(L"X");
			std::vector<Statement> fnb;

			fnb.push_back(VarAssignment(x, Literal(5L)));
			fnb.push_back(x);
			
			FnAssignment a(Variable(L"F"), FnDef(fnb));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseComments2)
		{
			std::wstring code =
				L"X←1 ⍝ one\n"
				L"V←2 ⍝ two\n";
			Parser p(code);
			Module res = p.parse();

			std::vector<Assignment> defs;

			defs.push_back(VarAssignment(Variable(L"X"), Literal(1L)));
			defs.push_back(VarAssignment(Variable(L"V"), Literal(2L)));

			Module exp(defs);

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseComments3)
		{
			Parser p(L"V←1 ⍝ one");
			Module res = p.parse();

			VarAssignment a(Variable(L"V"), Literal(1L));
			Module exp(std::vector<Assignment>(1, a));

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseBig2)
		{
			std::wstring code =
				L"easter←{                    ⍝ Easter Sunday in year ⍵.\n"
				L"	G←1+19|⍵                ⍝ year \"golden number\" in 19-year Metonic cycle.\n"
				L"	C←1+⌊⍵÷100              ⍝ Century: for example 1984 → 20th century.\n\n"
				L"	X←¯12+⌊C×3÷4            ⍝ number of years in which leap year omitted.\n"
				L"	Z←¯5+⌊(5+8×C)÷25        ⍝ synchronises Easter with moon's orbit.\n\n"
				L"	S←(⌊(5×⍵)÷4)-X+10       ⍝ find Sunday.\n"
				L"	E←30|(11×G)+20+Z-X      ⍝ Epact.\n"
				L"	F←E+(E=24)∨(E=25)^G>11  ⍝   (when full moon occurs).\n\n"
				L"	N←(30×F>23)+44-F        ⍝ find full moon.\n"
				L"	N←N+7-7|S+N             ⍝ advance to Sunday.\n\n"
				L"	M←3+N>31                ⍝ month: March or April.\n"
				L"	D←N-31×N>31             ⍝ day within month.\n"
				L"	↑10000 100 1+.×⍵ M D    ⍝ yyyymmdd.\n"
				L"}\n";

			Parser p(code);
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}

		TEST_METHOD(ParseBig3)
		{
			std::wstring code =
				L"mean←{      ⍝ Arithmetic mean.\n"
				L"	sum←+/⍵\n"
				L"	num←⍴⍵\n"
				L"	sum÷num\n"
				L"}\n";

			Parser p(code);
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}
		
		TEST_METHOD(ParseBig4)
		{
			std::wstring code =
				L"queens←{							⍝ The N-queens problem.\n\n"
				L"	search←{                        ⍝ Search for all solutions.\n"
				L"		(⊂⍬)∊⍵:0⍴⊂⍬                 ⍝ stitched: abandon this branch.\n"
				L"		0=⍴⍵:rmdups ⍺               ⍝ all done: solution!\n"
				L"		hd tl←(⊃⍵)(1↓⍵)             ⍝ head 'n tail of remaining ranks.\n"
				L"		next←⍺∘,¨hd                 ⍝ possible next steps.\n"
				L"		rems←hd free¨⊂tl            ⍝ unchecked squares.\n"
				L"		↑,/next ∇¨rems              ⍝ ... in following ranks.\n"
				L"	}\n\n"
				L"	cvex←(1+⍳⍵)×⊂¯1 0 1             ⍝ Checking vectors.\n\n"
				L"	free←{⍵~¨⍺+(⍴⍵)↑cvex}           ⍝ Unchecked squares.\n\n"
				L"	rmdups←{                        ⍝ Ignore duplicate solution.\n"
				L"		rots←{{⍒⍵}\\4/⊂⍵}            ⍝ 4 rotations.\n"
				L"		refs←{{⍋⍵}\\2/⊂⍵}            ⍝ 2 reflections.\n"
				L"		best←{(⊃⍋↑⍵)⊃⍵}             ⍝ best (=lowest) solution.\n"
				L"		all8←,↑refs¨rots ⍵          ⍝ all 8 orientations.\n"
				L"		(⍵≡best all8)⊃⍬(,⊂⍵)        ⍝ ignore if not best.\n"
				L"	}\n\n"
				L"	fmt←{                           ⍝ Format solution.\n"
				L"		chars←'·⍟'[(↑⍵)∘.=⍳⍺]       ⍝ char array of placed queens.\n"
				L"		expd←1↓,↑⍺⍴⊂0 1             ⍝ expansion mask.\n"
				L"		↑¨↓↓expd\\chars              ⍝ vector of char matrices.\n"
				L"	}\n\n"
				L"	squares←(⊂⍳⌈⍵÷2),1↓⍵⍴⊂⍳⍵        ⍝ initial squares\n\n"
				L"	⍵ fmt ⍬ search squares          ⍝ all distinct solutions.\n\n"
				L"}\n";

			Parser p(code);
			Module res = p.parse();

			Module exp;

			Assert::IsTrue(exp == res);
		}
	};
}