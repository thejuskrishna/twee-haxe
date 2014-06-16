/**
 * Twee
 * @author Sreenath Somarajapuram
 */

package tiger.twee.easing;

import tiger.twee.interfaces.IEase;

public class Exponential
{
	public static const easeIn:IEase = new EaseIn;
	public static const easeOut:IEase = new EaseOut;
	public static const easeInOut:IEase = new EaseInOut;
}

private class EaseIn implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return t == 0 ? s : c * Math.pow(2, 10 * (t / d - 1)) + s;
	}
}

private class EaseOut implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return t == d ? s + c : c * (-Math.pow(2, -10 * t / d) + 1) + s;
	}	
}

private class EaseInOut implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		if (t == 0)
			return s;
		
		if (t == d)
			return s + c;
		
		if ((t /= d / 2) < 1)
			return c / 2 * Math.pow(2, 10 * (t - 1)) + s;
		
		return c / 2 * (-Math.pow(2, -10 * --t) + 2) + s;
	}
}