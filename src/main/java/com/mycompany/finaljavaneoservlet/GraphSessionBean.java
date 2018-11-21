/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.finaljavaneoservlet;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.ejb.Stateless;

/**
 *
 * @author D064548
 */
@Stateless
public class GraphSessionBean implements GraphInterface {

    @Override
    public String[] getSimpleGuidedText(String queryResponse) {
        String text = null;
        Edge[] edges = new Edge[100];
        String subString = null;
        String steps = null;
        String direction = null;
        ArrayList<String> arrList = new ArrayList<>();
        int index = 0;
        int counter = 0;
        //StringBuilder arr = new StringBuilder();
        while (index != -1) {

            // get steps
            index = queryResponse.indexOf("steps", index + 1);
            //index = queryResponse.indexOf("direction", index + 1);
            if (index > 0) {
                int length = 0;
                do {
                    length++;
                    subString = queryResponse.substring(index + 6, index + 6 + length);
                } while (subString.matches("[0-9]") == true);
                steps = queryResponse.substring(index + 6, index + 6 + length - 1);
                edges[counter] = new Edge();
                edges[counter].steps = Integer.parseInt(steps);

                // now get direction
                index = queryResponse.indexOf("direction", index + 1);
                direction = queryResponse.substring(index + 11, index + 16);
                if ('e' == direction.charAt(0)) {
                    direction = "east";
                }
                if ('w' == direction.charAt(0)) {
                    direction = "west";
                }
                edges[counter].direction = direction;
                counter++;
            }
        }

        String oldDirection = null;
        String newDirection = null;
        int currentSteps = 0;
        String textFragment = null;

        for (int i = 0; i < counter; i++) {
            System.out.println(edges[i].steps);
            System.out.println(edges[i].direction);
        }

        for (int i = 0; i < counter; i++) {
            if (oldDirection != null) {
                newDirection = edges[i].direction;
                if (newDirection.compareTo(oldDirection) != 0) {
                    textFragment = "Walk " + currentSteps + " steps in direction " + oldDirection;
                    System.out.println(textFragment);
                    //arr.append(textFragment);
                    arrList.add(textFragment);
                    currentSteps = edges[i].steps;
                    oldDirection = edges[i].direction;
                } else {
                    currentSteps += edges[i].steps;
                };
            } else {
                oldDirection = edges[i].direction;
                currentSteps = edges[i].steps;
            }
        }
        textFragment = "Walk " + currentSteps + " steps in direction " + oldDirection;
        System.out.println(textFragment);
        arrList.add(textFragment);
        //text = arr.toString();
        String[] stockArr = new String[arrList.size()];
        stockArr = arrList.toArray(stockArr);
        return stockArr;

    }

    public class Edge {

        String direction;
        int steps;
    }

    @Override
    public String[] getDataForGraph(String response) {

        ArrayList<String> arrList = new ArrayList<>();

        String regex = "\\{type(.*?)\\}";
        Pattern pattern = Pattern.compile(regex, Pattern.DOTALL);
        Matcher matcher = pattern.matcher(response);
        while (matcher.find()) {
            System.out.print("Start index: " + matcher.start());
            System.out.print(" End index: " + matcher.end() + " ");
            System.out.println(matcher.group());
            arrList.add(matcher.group());
            //arrList.add(";");
        }
        String[] stockArr = new String[arrList.size()];
        stockArr = arrList.toArray(stockArr);
        System.out.println(stockArr.toString());
        return stockArr;

    }
}
