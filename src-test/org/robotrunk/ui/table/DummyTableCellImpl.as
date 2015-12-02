package org.robotrunk.ui.table {
	import flash.geom.Rectangle;

	import org.robotools.graphics.drawing.GraphRectangle;
	import org.robotrunk.ui.core.event.ViewEvent;
	import org.robotrunk.ui.table.impl.TableCellImpl;

	public class DummyTableCellImpl extends TableCellImpl {

		public function DummyTableCellImpl( data:XML ) {
			super( data );
		}

		override protected function render():void {
			dispatchEvent( new ViewEvent( ViewEvent.RENDER ) );
			new GraphRectangle( this ).createRectangle( new Rectangle( 0, 0, 60, 30 ) ).fill( 0, 1 ).draw();
			dispatchEvent( new ViewEvent( ViewEvent.RENDER_COMPLETE ) );
		}
	}
}
