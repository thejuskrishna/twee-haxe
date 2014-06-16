/**
 * Twee
 * @author Sreenath Somarajapuram
 */

package tiger.twee.easing;

import com.tiger.twee.interfaces.IEase;

class Quadratic
{
	public static const easeIn:IEase = new EaseIn;
	public static const easeOut:IEase = new EaseOut;
	public static const easeInOut:IEase = new EaseInOut;
}

private class EaseIn implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return c * (t /= d) * t + s;
	}
	public static var i:EaseIn = new EaseIn();
}

private class EaseOut implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return -c * (t /= d) * (t - 2) + s;
	}	
}

private class EaseInOut implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		if ((t /= d / 2) < 1)
			return c / 2 * t * t + s;
		
		return -c / 2 * ((--t) * (t - 2) - 1) + s;
	}
}