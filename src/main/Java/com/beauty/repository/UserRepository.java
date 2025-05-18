package com.beauty.repository;

import com.beauty.model.User;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Repository class for handling file-based user storage operations
 */
public class UserRepository {
    private static final String USER_DATA_FILE = "C:\\Users\\Sedara\\OneDrive\\Desktop\\Beauty_version 01 (2)\\Beauty_version 01\\Beauty\\src\\main\\webapp\\Database\\users.txt";

    /**
     * Save a new user to the file
     * @param user The user to save
     * @return true if successful, false otherwise
     */
    public boolean saveUser(User user) {
        List<User> users = getAllUsers();

        // Check if user with the same email already exists
        for (User existingUser : users) {
            if (existingUser.getEmail().equals(user.getEmail())) {
                return false; // User already exists
            }
        }

        // Add the new user
        users.add(user);

        // Save the updated list back to the file
        return saveAllUsers(users);
    }

    /**
     * Get a user by email
     * @param email The email to search for
     * @return The user if found, null otherwise
     */
    public User getUserByEmail(String email) {
        List<User> users = getAllUsers();

        for (User user : users) {
            if (user.getEmail().equals(email)) {
                return user;
            }
        }

        return null; // User not found
    }

    /**
     * Authenticate a user with email and password
     * @param email The email
     * @param password The password
     * @return The authenticated user if successful, null otherwise
     */
    public User authenticateUser(String email, String password) {
        User user = getUserByEmail(email);

        if (user != null && user.getPassword().equals(password)) {
            return user;
        }

        return null; // Authentication failed
    }

    /**
     * Update an existing user
     * @param updatedUser The updated user information
     * @return true if successful, false otherwise
     */
    public boolean updateUser(User updatedUser) {
        List<User> users = getAllUsers();
        boolean found = false;

        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            if (user.getEmail().equals(updatedUser.getEmail())) {
                users.set(i, updatedUser);
                found = true;
                break;
            }
        }

        if (!found) {
            return false; // User not found
        }

        return saveAllUsers(users);
    }

    /**
     * Delete a user by email
     * @param email The email of the user to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteUser(String email) {
        List<User> users = getAllUsers();
        boolean removed = false;

        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getEmail().equals(email)) {
                users.remove(i);
                removed = true;
                break;
            }
        }

        if (!removed) {
            return false; // User not found
        }

        return saveAllUsers(users);
    }

    /**
     * Get all users from the file
     * @return List of all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        File file = new File(getUserDataFilePath());

        // If file doesn't exist or is empty, return empty list
        if (!file.exists() || file.length() == 0) {
            return users;
        }

        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
            users = (List<User>) ois.readObject();
        } catch (FileNotFoundException e) {
            // File not found, return empty list
        } catch (EOFException e) {
            // Empty file or corrupted, return empty list
            System.out.println("Empty or corrupted file: " + e.getMessage());
        } catch (IOException | ClassNotFoundException e) {
            System.out.println("Error reading user data: " + e.getMessage());
            e.printStackTrace();
        }

        return users;
    }

    /**
     * Save all users to the file
     * @param users The list of users to save
     * @return true if successful, false otherwise
     */
    private boolean saveAllUsers(List<User> users) {
        File file = new File(getUserDataFilePath());

        // Create parent directories if they don't exist
        File parentDir = file.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }

        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(file))) {
            oos.writeObject(users);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get the full path to the user data file
     * @return The file path
     */
    private String getUserDataFilePath() {
        return USER_DATA_FILE;
    }
}
