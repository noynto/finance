package me.noynto.finance.domain.bankaccount;

public enum Bank {
    CA("Crédit Agricole", "CA");

    private String name;
    private String abbreviate;

    Bank(String name, String abbreviate) {
        this.name = name;
        this.abbreviate = abbreviate;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAbbreviate() {
        return abbreviate;
    }

    public void setAbbreviate(String abbreviate) {
        this.abbreviate = abbreviate;
    }
}
