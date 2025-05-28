/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.intranet_escolar.util;

import org.mindrot.jbcrypt.BCrypt;

public class test2 {
    public static void main(String[] args) {
        String nuevoHash = BCrypt.hashpw("123456", BCrypt.gensalt(12));
System.out.println(nuevoHash);

    }
}
