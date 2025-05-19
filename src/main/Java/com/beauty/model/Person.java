package com.beauty.model;

public class Person extends User {
    private String role;

    public Person() {
        super();
    }

    public Person(String firstName, String lastName, String email, String phoneNumber, String password, String role) {
        super(firstName, lastName, email, phoneNumber, password);
        this.role = role;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "Person{" +
                "firstName='" + getFirstName() + '\'' +
                ", lastName='" + getLastName() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", phoneNumber='" + getPhoneNumber() + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}