package bean;

public class Allergen {
	private String allergenId;
	private String allergenName;

	// コンストラクタ
	public Allergen() {
	}

	// Getter and Setter
	public String getAllergenId() {
		return allergenId;
	}

	public void setAllergenId(String allergenId) {
		this.allergenId = allergenId;
	}

	public String getAllergenName() {
		return allergenName;
	}

	public void setAllergenName(String allergenName) {
		this.allergenName = allergenName;
	}
}