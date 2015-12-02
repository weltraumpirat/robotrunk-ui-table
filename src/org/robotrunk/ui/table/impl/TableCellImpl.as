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
	import flash.display.Sprite;
	import flash.events.Event;

	import org.robotrunk.common.error.AbstractMethodInvocationException;
	import org.robotrunk.ui.table.api.TableCell;

	public class TableCellImpl extends Sprite implements TableCell {
		private var _data:XML;
		private var _colspan:int = 1;
		private var _rowspan:int = 1;

		public function TableCellImpl( data:XML ) {
			_data = data;
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}

		private function onAddedToStage( ev:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			render();
		}

		protected function render():void {
			throw new AbstractMethodInvocationException( "You must override the render() method" );
		}

		public function get data():XML {
			return _data;
		}

		public function get colspan():int {
			return _data.@colspan != null ? parseInt( _data.@colspan ) : _colspan;
		}

		public function set colspan( value:int ):void {
			_colspan = value;
		}

		public function get rowspan():int {
			return _data.@rowspan != null ? parseInt( _data.@rowspan ) : _rowspan;
		}

		public function set rowspan( value:int ):void {
			_rowspan = value;
		}
	}
}
