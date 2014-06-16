/**
 * Twee
 * @author Sreenath Somarajapuram
 */

package tiger.twee.easing;

import tiger.twee.interfaces.IEase;

class Quartic
{
	public static const easeIn:IEase = new EaseIn;
	public static const easeOut:IEase = new EaseOut;
	public static const easeInOut:IEase = new EaseInOut;
}

private class EaseIn implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return c * (t /= d) * t * t * t + s;
	}
}

private class EaseOut implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return -c * ((t = t / d - 1) * t * t * t - 1) + s;
	}	
}

private class EaseInOut implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		if ((t /= d / 2) < 1)
			return c / 2 * t * t * t * t + s;
		return -c / 2 * ((t -= 2) * t * t * t - 2) + s;
	}
}
