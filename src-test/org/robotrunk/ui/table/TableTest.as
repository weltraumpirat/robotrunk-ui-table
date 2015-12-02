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
	import flash.display.DisplayObject;

	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotrunk.ui.core.event.ViewEvent;
	import org.robotrunk.ui.table.api.Table;
	import org.robotrunk.ui.table.impl.TableCellRenderer;
	import org.robotrunk.ui.table.impl.TableImpl;

	public class TableTest {

		private var table:Table;

		[Before]
		public function setUp():void {
			table = new TableImpl();
		}

		[Test]
		public function acceptsXMLDataProvider():void {
			var data:XML = new XML();
			table.dataProvider = data;
			assertEquals( data, table.dataProvider );
		}

		[Test]
		public function holdsCellRenderers():void {
			var renderer:TableCellRenderer = new TableCellRenderer( DummyTableCellImpl );
			table.addRenderer( "test", renderer );
			assertEquals( renderer, table.renderers["test"] );
		}

		[Test(async)]
		public function rendersTableCellsFromXML():void {
			setUpForRendering();
			table.addEventListener( ViewEvent.RENDER_COMPLETE,
									Async.asyncHandler( this, function ( ev:ViewEvent, ...rest ):void {
										assertEquals( 4, table.cells.length );
									}, 500 ) );
			table.render();
		}

		[Test(async)]
		public function cellSpanGrowsCellsAcrossColumns():void {
			setUpForRendering();
			table.addEventListener( ViewEvent.RENDER_COMPLETE,
									Async.asyncHandler( this, function ( ev:ViewEvent, ...rest ):void {
										var row1:ArrayCollection = table.rows.getItemAt( 0 ) as ArrayCollection;
										var row2:ArrayCollection = table.rows.getItemAt( 1 ) as ArrayCollection;

										assertEquals( 60, row1.getItemAt( 0 ).width );
										assertEquals( 60, row1.getItemAt( 1 ).width );
										assertEquals( 60, row1.getItemAt( 2 ).width );

										assertEquals( 120, row2.getItemAt( 0 ).width );
									}, 500 ) );
			table.render();

		}

		[Test(async)]
		public function rowSpanGrowsCellsAcrossRows():void {
			setUpForRendering();
			table.addEventListener( ViewEvent.RENDER_COMPLETE,
									Async.asyncHandler( this, function ( ev:ViewEvent, ...rest ):void {
										var row1:ArrayCollection = table.rows.getItemAt( 0 ) as ArrayCollection;
										var row2:ArrayCollection = table.rows.getItemAt( 1 ) as ArrayCollection;

										assertEquals( 60, row1.getItemAt( 0 ).height );
										assertEquals( 30, row1.getItemAt( 1 ).height );
										assertEquals( 30, row1.getItemAt( 2 ).height );

										assertEquals( 30, row2.getItemAt( 0 ).height );
									}, 500 ) );
			table.render();
		}

		[Test(async)]
		public function cellsArePlacedCorrectly():void {
			setUpForRendering();
			table.addEventListener( ViewEvent.RENDER_COMPLETE,
									Async.asyncHandler( this, function ( ev:ViewEvent, ...rest ):void {
										var row1:ArrayCollection = table.rows.getItemAt( 0 ) as ArrayCollection;
										var row2:ArrayCollection = table.rows.getItemAt( 1 ) as ArrayCollection;

										assertEquals( 0, row1.getItemAt( 0 ).x );
										assertEquals( 60, row1.getItemAt( 1 ).x );
										assertEquals( 120, row1.getItemAt( 2 ).x );

										assertEquals( 60, row2.getItemAt( 0 ).x );

										assertEquals( 0, row1.getItemAt( 0 ).y );
										assertEquals( 0, row1.getItemAt( 1 ).y );
										assertEquals( 0, row1.getItemAt( 2 ).y );

										assertEquals( 30, row2.getItemAt( 0 ).y );
									}, 500 ) );
			table.render();
		}

		[Test(async)]
		public function dispatchesViewEventWhenRenderingStarts():void {
			setUpForRendering();
			Async.proceedOnEvent( this, table, ViewEvent.RENDER );
			table.render();
		}

		[Test(async)]
		public function dispatchesViewEventWhenRenderingFinishes():void {
			setUpForRendering();
			Async.proceedOnEvent( this, table, ViewEvent.RENDER_COMPLETE );
			table.render();
		}

		private function setUpForRendering():void {
			table.addRenderer( "cell", new TableCellRenderer( DummyTableCellImpl ) );
			table.addRenderer( "header", new TableCellRenderer( DummyTableCellImpl ) );
			table.dataProvider = createTableXML();
			var container:UIComponent = new UIComponent();
			UIImpersonator.addChild( container );
			container.addChild( table as DisplayObject );
		}

		private function createTableXML():XML {
			return <table>
				<row>
					<cell type="header" rowspan="2"/>
					<cell  type="header" />
					<cell  type="header" />
				</row>
				<row>
					<cell colspan="2" />
				</row>
			</table>;
		}

		[After]
		public function tearDown():void {
			UIImpersonator.removeAllChildren();
			table.destroy();
			table = null;
		}
	}
}