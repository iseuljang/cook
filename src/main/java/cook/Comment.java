package cook;

public class Comment {
	private String cno;
	private String no;
	private String uno;
	private String content;
	private String state;
	private String rdate;
	private String unick;
	
	public Comment() {}

	public Comment(String cno, String no, String uno, String content, String state, String rdate, String unick) {
		this.cno = cno;
		this.no = no;
		this.uno = uno;
		this.content = content;
		this.state = state;
		this.rdate = rdate;
		this.unick = unick;
	}

	public String getCno() {
		return cno;
	}

	public String getNo() {
		return no;
	}

	public String getUno() {
		return uno;
	}

	public String getContent() {
		return content;
	}

	public String getState() {
		return state;
	}

	public String getRdate() {
		return rdate;
	}

	public String getUnick() {
		return unick;
	}

	public void setCno(String cno) {
		this.cno = cno;
	}

	public void setNo(String no) {
		this.no = no;
	}

	public void setUno(String uno) {
		this.uno = uno;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public void setState(String state) {
		this.state = state;
	}

	public void setRdate(String rdate) {
		this.rdate = rdate;
	}

	public void setUnick(String unick) {
		this.unick = unick;
	}
	
	
}
