package cook;

public class PagingUtil {  //(o) : �ݵ�� �ʿ�
	// o : �ܺο��� �޾ƿ� ���꿡 �ʿ��� �����͸� ���� �ʵ�
	// o ���� : o �����͵��� Ȱ���Ͽ� ����� ����� ���� �ʵ�
	private int nowPage;   //������������ȣ(o)
	private int startPage; //������������ȣ
	private int endPage;   //������������ȣ
	private int total;	   //��ü �Խñ� ��(o)
	private int perPage;   //�� �������� �Խñ� ����(o)
	private int lastPage;  //���� ������ ��ȣ
	private int start;     //���� �Խñ� ��ȣ
	private int end;       //���� �Խñ� ��ȣ
	private int cntPage=5; //�� ���������� �������� ����¡ ��ȣ ��(o)
	
	public PagingUtil() {}
	public PagingUtil(int nowPage,int total, int perPage) {
		setNowPage(nowPage);
		setTotal(total);
		setPerPage(perPage);
		
		calcStartEnd(nowPage,perPage); //���۹�ȣ �����ȣ ���� ��� ȣ��
		calcLastPage(total, perPage);
		calcStartEndPage(nowPage,cntPage);
	}
	
	public void calcStartEnd(int nowPage,int perPage) {
		int end = nowPage * perPage; //�Խñ� �����ȣ(oracle���� ���)
		/*
		���� ������ : 1 / �Խñ� ���� ���� : 5
		�����ȣ : 1*5 -> 5
		���۹�ȣ : �����ȣ - �Խñ� ���� ����(5-5 = 0) 
		--> limit 0,5
		���� ������ : 2 / �Խñ� ���� ���� : 5
		�����ȣ : 2*5 -> 10
		���۹�ȣ : �����ȣ - �Խñ� ���� ����(10-5 = 5)
		--> limit 5,5
		*/
		int start = end - perPage; //�Խñ� ���۹�ȣ.(oracle������ +1�� �ؾ���)
		
		setEnd(end);
		setStart(start);
	}
	
	//�� 11�� ���������� 10���� ������ ���� ��ȣ : 2
	public void calcLastPage(int total, int perPage) {
		//��ü �Խñۿ��� �������� �Խñ� ���� ���� �Ǽ��� �ø�ó�� �� ���� ��ȯ
		int lastPage = (int)Math.ceil((double)total/perPage);
		setLastPage(lastPage);
	}
	
	//���������� : 3 / ���������� ��ȣ : 1 / ���������� ��ȣ : 10
	public void calcStartEndPage(int nowPage,int cntPage) {
		//���� �������� 10�� �ڸ��� ���ؿ� +1�� �� �� �������� ���� ������ ���� ���ϱ�
		int endPage = (int)Math.ceil((double)nowPage / cntPage) * cntPage;
		
		int startPage = endPage - cntPage + 1;

		if(endPage > lastPage) {
			endPage = lastPage;
		}
		
		setEndPage(endPage);
		setStartPage(startPage);
	}
	
	public int getNowPage() {return nowPage;}
	public int getStartPage() {return startPage;}
	public int getEndPage() {return endPage;}
	public int getTotal() {return total;	}
	public int getPerPage() {return perPage;	}
	public int getLastPage() {return lastPage;	}
	public int getStart() {return start;	}
	public int getEnd() {return end;	}
	public int getCntPage() {return cntPage;	}
	
	public void setNowPage(int nowPage) {	this.nowPage = nowPage;	}
	public void setStartPage(int startPage) {	this.startPage = startPage;	}
	public void setEndPage(int endPage) {this.endPage = endPage;	}
	public void setTotal(int total) {this.total = total;	}
	public void setPerPage(int perPage) {this.perPage = perPage;	}
	public void setLastPage(int lastPage) {	this.lastPage = lastPage;	}
	public void setStart(int start) {this.start = start;	}
	public void setEnd(int end) {this.end = end;	}
	public void setCntPage(int cntPage) {this.cntPage = cntPage;	}
	
	
	
}
