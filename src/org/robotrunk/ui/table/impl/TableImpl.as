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

package org.robotrunk.ui.table.impl {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;

	import org.robotrunk.common.error.IllegalOperationException;
	import org.robotrunk.ui.core.Position;
	import org.robotrunk.ui.core.Style;
	import org.robotrunk.ui.core.event.ViewEvent;
	import org.robotrunk.ui.table.api.Table;
	import org.robotrunk.ui.table.api.TableCell;

	public class TableImpl extends Sprite implements Table {
		private var _style:Style;
		private var _states:Dictionary = new Dictionary( true );
		private var _position:Position;
		private var _renderers:Dictionary;
		private var _cells:ArrayCollection;
		private var _rows:ArrayCollection;
		private var _grid:Grid;
		private var _dataProvider:XML;
		private var _renderedItems:int = 0;

		public function addRenderer( name:String, renderer:TableCellRenderer ):void {
			_renderers ||= new Dictionary();
			_renderers[name] = renderer;
		}

		public function render():void {
			dispatchRender();
			_renderedItems = 0;
			_rows ||= new ArrayCollection();
			_cells ||= new ArrayCollection();

			for each( var header:XML in _dataProvider.header ) {
				_rows.addItem( renderRow( header ) );
			}

			for each( var row:XML in _dataProvider.row ) {
				_rows.addItem( renderRow( row ) );
			}

			for each( var cell:TableCell in _cells ) {
				addChild( cell as DisplayObject );
			}
		}

		private function renderRow( row:XML ):ArrayCollection {
			var rowItem:ArrayCollection = new ArrayCollection();
			for each ( var cell:XML in row.cell ) {
				var cellItem:TableCell = renderCell( cell );
				cellItem.addEventListener( ViewEvent.RENDER_COMPLETE, onItemRenderComplete, false, 0, true );
				rowItem.addItem( cellItem );
				_cells.addItem( cellItem );
			}
			return rowItem;
		}

		private function onItemRenderComplete( ev:ViewEvent ):void {
			ev.target.removeEventListener( ViewEvent.RENDER_COMPLETE, onItemRenderComplete );
			if( ++_renderedItems>=_cells.length ) {
				layout();
			}
		}

		private function renderCell( cell:XML ):TableCell {
			var type:String = cell.@type.toString();
			type = type == null || type == "" ? "cell" : type;
			return _renderers[type].create( cell );
		}

		private function layout():void {
			_grid = new Grid( rows );
			var widths:Array = calculateColumnWidths();
			var heights:Array = calculateRowHeights();
			applyDimensions( widths, heights );
			dispatchRenderComplete();
		}

		private function calculateColumnWidths():Array {
			var widths:Array = [];
			var i:int = -1;
			while( ++i<_grid.columns ) {
				widths[i] = getColumnWidth( i );
			}
			return widths;
		}

		private function getColumnWidth( index:int ):Number {
			var wid:Number = 0;
			var i:int = -1;
			while( ++i<_grid.rows ) {
				var cell:TableCell = _grid.getItemAt( i, index );
				if( cell && cell.colspan<2 ) {
					wid = wid>cell.width ? wid : cell.width;
				}
			}
			return wid;
		}

		private function calculateRowHeights():Array {
			var heights:Array = [];
			var i:int = -1;
			while( ++i<_grid.rows ) {
				heights[i] = getRowHeight( i );
			}
			return heights;
		}

		private function getRowHeight( index:int ):Number {
			var hei:Number = 0;
			var i:int = -1;
			while( ++i<_grid.columns ) {
				var cell:TableCell = _grid.getItemAt( index, i );
				if( cell ) {
					hei = hei>cell.height ? hei : cell.height;
				}
			}
			return hei;
		}

		private function applyDimensions( widths:Array, heights:Array ):void {
			var ypos:Number = 0;
			var row:int = -1;
			var offset:Number = style && style.offset ? style.offset : 0;
			while( ++row<_grid.rows ) {
				var column:int = -1;
				var xpos:Number = 0;
				while( ++column<_grid.columns ) {
					var cell:TableCell = _grid.getItemAt( row, column );
					if( cell ) {
						cell.x = xpos;
						cell.y = ypos;
						cell.width = getCellWidth( cell, widths, column );
						cell.height = getCellHeight( cell, heights, row );
					}
					xpos += widths[column]+offset;
				}
				ypos += heights[row]+offset;
			}
		}

		private function getCellWidth( cell:TableCell, widths:Array, startColumn:int ):Number {
			var wid:Number = widths[startColumn];
			var offset:Number = style && style.offset ? style.offset : 0;
			if( cell.colspan>0 ) {
				var i:int = startColumn;
				while( ++i<startColumn+cell.colspan ) {
					wid += widths[i]+offset;
				}
			}
			return wid;
		}

		private function getCellHeight( cell:TableCell, heights:Array, row:int ):Number {
			var hei:Number = heights[row];
			var offset:Number = style && style.offset ? style.offset : 0;
			if( cell.rowspan>0 ) {
				var i:int = row;
				while( ++i<row+cell.rowspan ) {
					hei += heights[i]+offset;
				}
			}
			return hei;
		}

		public function destroy():void {
			_style = null;
			_states = null;
			_position = null;
			_renderers = null;
			_dataProvider = null;
		}

		private function dispatchRender():void {
			dispatchEvent( new ViewEvent( ViewEvent.RENDER ) );
		}

		private function dispatchRenderComplete():void {
			dispatchEvent( new ViewEvent( ViewEvent.RENDER_COMPLETE ) );
		}

		public function get position():Position {
			return _position;
		}

		public function set position( position:Position ):void {
			_position = position;
		}

		public function get currentState():String {
			return "default";
		}

		public function set currentState( currentState:String ):void {
			throw new IllegalOperationException( "Table does not allow switching states; its only state is 'default'." );
		}

		public function get states():Dictionary {
			return _states;
		}

		public function set states( states:Dictionary ):void {
			_states = states;
		}

		public function get style():Style {
			return _style;
		}

		public function set style( style:Style ):void {
			_style = style;
		}

		public function get dataProvider():XML {
			return _dataProvider;
		}

		public function set dataProvider( value:XML ):void {
			_dataProvider = value;
		}

		public function get renderers():Dictionary {
			return _renderers;
		}

		public function get cells():ArrayCollection {
			return _cells;
		}

		public function set cells( value:ArrayCollection ):void {
			_cells = value;
		}

		public function get rows():ArrayCollection {
			return _rows;
		}

		public function set rows( value:ArrayCollection ):void {
			_rows = value;
		}

		public function applyToStyles( property:String, value:* ):void {
		}
	}
}
