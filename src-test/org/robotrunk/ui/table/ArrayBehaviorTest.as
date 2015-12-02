/*
 * Copyright (c) 2012 Tobias Goeschel.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package org.robotrunk.ui.table {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class ArrayBehaviorTest {
		[Test]
		public function evaluatesToFalseIfItemForIndexNotSpecified():void {
			var arr:Array = [];
			assertEquals( 0, arr.length );
			assertFalse( arr[0] );
			assertFalse( arr[1] );
			assertFalse( arr[2] );
		}

		[Test]
		public function evaluatesToFalseIfItemForIndexIsNull():void {
			var arr:Array = [null, null, null];
			assertEquals( 3, arr.length );
			assertFalse( arr[0] );
			assertFalse( arr[1] );
			assertFalse( arr[2] );
		}

		[Test]
		public function evaluatesToFalseIfItemForIndexIsZero():void {
			var arr:Array = [0, 0, 0];
			assertEquals( 3, arr.length );
			assertFalse( arr[0] );
			assertFalse( arr[1] );
			assertFalse( arr[2] );
		}

		[Test]
		public function evaluatesToTrueIfItemForIndexHasNumberValueGreaterThanZero():void {
			var arr:Array = [1, 2, 3];
			assertEquals( 3, arr.length );
			assertTrue( arr[0] );
			assertTrue( arr[1] );
			assertTrue( arr[2] );
		}

		[Test]
		public function evaluatesToTrueIfItemForIndexHasNumberValueSmallerThanZero():void {
			var arr:Array = [-1, -2, -3];
			assertEquals( 3, arr.length );
			assertTrue( arr[0] );
			assertTrue( arr[1] );
			assertTrue( arr[2] );
		}

		[Test]
		public function evaluatesToTrueIfItemForIndexHasStringValue():void {
			var arr:Array = ["one", "two", "three"];
			assertEquals( 3, arr.length );
			assertTrue( arr[0] );
			assertTrue( arr[1] );
			assertTrue( arr[2] );
		}

		[Test]
		public function evaluatesToFalseIfItemForIndexHasEmptyStringValue():void {
			var arr:Array = [""];
			assertEquals( 1, arr.length );
			assertFalse( arr[0] );
		}
	}
}