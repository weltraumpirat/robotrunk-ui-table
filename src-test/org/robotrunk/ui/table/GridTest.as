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
	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.robotrunk.ui.table.impl.Grid;

	public class GridTest {
		private var grid:Grid;

		[Before]
		public function setUp():void {
			grid = new Grid( createTable(), 3, 2 );
		}

		[Test]
		public function gridAssumesContentSizeIfNoneIsSpecified():void {
			grid = new Grid( createTable() );
			assertEquals( 2, grid.columns );
			assertEquals( 2, grid.rows );
		}

		[Test]
		public function gridAssumesContentSizeIfSmallerThanContent():void {
			grid = new Grid( createTable(), 1, 1 );
			assertEquals( 2, grid.columns );
			assertEquals( 2, grid.rows );
		}

		[Test]
		public function gridAssumesGivenSizeIfLargerThanContent():void {
			grid = new Grid( createTable(), 5, 5 );
			assertEquals( 5, grid.columns );
			assertEquals( 5, grid.rows );
		}

		[Test]
		public function tableCellsAreAssignedInCorrectOrder():void {
			assertEquals( "<cell rowspan=\"2\"/>", grid.getItemAt( 0, 0 ).data.toXMLString() );
			assertEquals( "<cell/>", grid.getItemAt( 0, 1 ).data.toXMLString() );
			assertEquals( "<cell/>", grid.getItemAt( 0, 2 ).data.toXMLString() );
			assertNull( grid.getItemAt( 1, 0 ) );
			assertEquals( "<cell colspan=\"2\"/>", grid.getItemAt( 1, 1 ).data.toXMLString() );
			assertNull( grid.getItemAt( 1, 2 ) );
		}

		[Test]
		public function exoticTableIsRenderedCorrectly():void {
			grid = new Grid( createExoticTable() );
			assertEquals( "<cell rowspan=\"3\"/>", grid.getItemAt( 0, 0 ).data.toXMLString() );
			assertEquals( "<cell rowspan=\"3\"/>", grid.getItemAt( 0, 1 ).data.toXMLString() );
			assertEquals( "<cell colspan=\"3\"/>", grid.getItemAt( 0, 2 ).data.toXMLString() );
			assertNull( grid.getItemAt( 1, 0 ) );
			assertNull( grid.getItemAt( 1, 1 ) );
			assertEquals( "<cell/>", grid.getItemAt( 1, 2 ).data.toXMLString() );
			assertEquals( "<cell/>", grid.getItemAt( 1, 3 ).data.toXMLString() );
			assertNull( grid.getItemAt( 2, 0 ) );
			assertNull( grid.getItemAt( 2, 1 ) );
			assertEquals( "<cell/>", grid.getItemAt( 2, 2 ).data.toXMLString() );
			assertEquals( "<cell/>", grid.getItemAt( 2, 3 ).data.toXMLString() );

		}

		private function createExoticTable():ArrayCollection {
			var rows:ArrayCollection = new ArrayCollection();
			var row1:ArrayCollection = new ArrayCollection();
			row1.addItem( new DummyTableCellImpl( <cell rowspan="3" /> ) );
			row1.addItem( new DummyTableCellImpl( <cell rowspan="3" /> ) );
			row1.addItem( new DummyTableCellImpl( <cell colspan="3" /> ) );
			var row2:ArrayCollection = new ArrayCollection();
			row2.addItem( new DummyTableCellImpl( <cell  /> ) );
			row2.addItem( new DummyTableCellImpl( <cell  /> ) );
			var row3:ArrayCollection = new ArrayCollection();
			row3.addItem( new DummyTableCellImpl( <cell  /> ) );
			row3.addItem( new DummyTableCellImpl( <cell  /> ) );
			rows.addItem( row1 );
			rows.addItem( row2 );
			rows.addItem( row3 );
			return rows;
		}

		private function createTable():ArrayCollection {
			var rows:ArrayCollection = new ArrayCollection();
			var row1:ArrayCollection = new ArrayCollection();
			row1.addItem( new DummyTableCellImpl( <cell rowspan="2" /> ) );
			row1.addItem( new DummyTableCellImpl( <cell /> ) );
			row1.addItem( new DummyTableCellImpl( <cell /> ) );
			var row2:ArrayCollection = new ArrayCollection();
			row2.addItem( new DummyTableCellImpl( <cell colspan="2" /> ) );
			rows.addItem( row1 );
			rows.addItem( row2 );
			return rows;
		}

		[After]
		public function tearDown():void {
			grid = null;
		}
	}
}