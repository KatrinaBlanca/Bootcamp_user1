public with sharing class TEST_RadioButtons {
	public List<Row> rows { get; set; }
	public String selectedValue { get; set; }
		 
	public TEST_RadioButtons() {
		rows = new List<Row>();
		rows.add(new Row('va', 'la'));
		rows.add(new Row('vb', 'lb'));
		rows.add(new Row('vc', 'lc'));
	}
 
	public PageReference test() {
		System.debug('SFDC: ' + selectedValue);
		return null;
	} 
 
	public class Row {
		public String Value { get; set; }
		public String Label { get; set; }
		public Boolean isChecked { get; set; }
		
		public Row(String Value, String Label) {
			this.Value = Value;
			this.Label = Label;
		} 
	}
}