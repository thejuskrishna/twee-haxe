/**
 * Twee
 * @author Sreenath Somarajapuram
 */

package tiger.twee.easing;

import tiger.twee.interfaces.IEase;

class Linear{
	public static const easeNone:IEase = new LinearEase;
	public static const easeIn:IEase = easeNone;
	public static const easeOut:IEase = easeNone;
	public static const easeInOut:IEase = easeNone;
}

private class LinearEase implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return c * t / d + s;
	}
}


