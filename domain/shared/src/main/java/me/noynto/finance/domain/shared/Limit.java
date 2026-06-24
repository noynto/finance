package me.noynto.finance.domain.shared;

public class Limit {
    private Integer value;

    public Limit(Integer value) {
        this.value = value;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }
}
