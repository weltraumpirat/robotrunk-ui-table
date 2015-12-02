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
	import mx.collections.ArrayCollection;

	import org.robotrunk.ui.table.api.TableCell;
	import org.robotrunk.ui.table.error.OutOfGridBoundsException;

	public class Grid {
		private var _rows:int;
		private var _columns:int;
		private var _data:ArrayCollection;
		private var _grid:Array;
		private var _rowspan:Array = [];

		public function Grid( data:ArrayCollection, columns:int = 1, rows:int = 1 ) {
			_data = data;
			_rows = maxRows( rows );
			_columns = maxColumns( columns );
			buildGrid();
		}

		private function maxRows( rows:int ):int {
			var maxDataRows:Number = getMaxDataRows();
			return maxDataRows>rows ? maxDataRows : rows;
		}

		private function getMaxDataRows():Number {
			var max:int = _data.length;
			for each( var row:ArrayCollection in _data ) {
				var rowIdx:int = _data.getItemIndex( row );
				for each( var cell:TableCell in row ) {
					var maxspan:int = rowIdx+(cell.rowspan>1 ? cell.rowspan : 1);
					max = max<maxspan ? maxspan : max;
				}
			}
			return max;
		}

		private function maxColumns( columns:int ):int {
			var count:int = columns;
			for each( var row:ArrayCollection in _data ) {
				for each( var cell:TableCell in row ) {
					var cellIdx:int = row.getItemIndex( cell );
					var maxspan:int = cellIdx+(cell.colspan>1 ? cell.colspan : 1);
					count = maxspan>count ? maxspan : count;
				}
			}
			return count;
		}

		private function buildGrid():void {
			_grid = [];
			var i:int = -1;
			for each( var row:ArrayCollection in _data ) {
				_grid[++i] = buildGridRow( row );
			}

			nullFillRemainingRows( i );
		}

		private function buildGridRow( row:ArrayCollection ):Array {
			var gridRow:Array = [];
			var j:int = -1;
			for each( var cell:TableCell in row ) {
				while( ++j<_columns ) {
					if( hasRowSpan( j ) ) {
						_rowspan[j] = getDecreasedRowspanOrNull( _rowspan[j] );
					}
					else {
						gridRow[j] = cell;

						_rowspan[j] = getDecreasedRowspanOrNull( cell.rowspan );
						if( cell.colspan>1 ) {
							j += cell.colspan-1;
						}
						break;
					}
				}
			}
			return nullFillRemainingCells( gridRow, j );
		}

		private function hasRowSpan( j:int ):* {
			return j<_rowspan.length && _rowspan[j];
		}

		private function getDecreasedRowspanOrNull( span:* ):* {
			return span && span>1 ? span-1 : null;
		}

		private function nullFillRemainingCells( row:Array, j:int ):Array {
			while( ++j<_columns ) {
				row[j] = null;
			}
			return row;
		}

		private function nullFillRemainingRows( i:int ):void {
			while( ++i<_rows ) {
				_grid[i] = [];
				var j:int = -1;
				while( ++j<_columns ) {
					_grid[i][j] = null;
				}
			}
		}

		public function getItemAt( y:int, x:int ):TableCell {
			if( y>=_rows ) {
				throw new OutOfGridBoundsException( "Row at index "+y+" does not exist. The grid has only "+_rows+" rows." );
			}
			if( x>=_columns ) {
				throw new OutOfGridBoundsException( "Column at index "+x+" does not exist. The grid has only "+_columns+" columns." );
			}
			var ret:TableCell = null;
			try { ret = _grid[y][x] } catch( ignore:Error ) {}
			return ret;
		}

		public function get rows():int {
			return _rows;
		}

		public function get columns():int {
			return _columns;
		}

		public function get data():ArrayCollection {
			return _data;
		}
	}
}
