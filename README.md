# Demo_Posts-List
Demo App to list Post from a JSON file (simulating request) Use a mock for this purpose. Implementation using RxSwift, in MVVM pattern. 

Show Posts List:

When the app appear, you can watch a fake requested of List of Posts From a File 

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 02 55 08](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/c403983a-e5b3-470f-ba47-0188a23686bb)

Insert Posts:

To add a new Post, you must click to the button '+' on right-top of the view. Then You will see an alert with TextField waiting for Name and Description to Add.

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 02 57 45](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/a61a5e89-4e5c-45d8-b3b0-08c1b96df8b5)

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 02 58 28](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/40f319b0-1bbf-4840-b8e9-c6204ef0e54a)

If you don't type some of both textField then you'll see an alert Advice with the specific text . 

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 03 09 54](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/d24015a4-2521-4db5-a98c-93852bf2bbad)

Also if you try to add an existing post (exactly the same name and description) the app'll show you a specific alert advice

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 03 12 00](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/ef79de56-c89e-462f-9e45-60e587224833)

Remove Posts:

To delete any Post , please use slide on the left gesture with your fingers or mouse. If you do it from the right side to the left side the  post will be removed from the list.

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 03 00 08](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/046e6c23-e36a-4909-8463-5066fc286850)

Also you can make a small slide gesture from the right side to the left side, then the app'll show you a new Item for delete in the items expected

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 03 00 31](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/ac2fa226-f3ce-46be-bfe5-9f95ca47011a)

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 03 00 40](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/9ec8157d-98b6-46cf-8f19-eac8dfe94929)

Filter Posts:

Introduce a letter or word to search in the list in the textField on the top of the view so anytime than you type a letter the app'll be searching and filtering elements from the post list

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 03 02 09](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/e3864cdb-87fb-42fc-b6c8-3a3a3440b58d)

If you filter by words than doesn't exist in the list or you removed all the posts then the app will show you an empty image state

![Simulator Screenshot - iPhone 14 Pro - 2023-05-27 at 03 02 18](https://github.com/ChrisCalix/Demo_Posts-List/assets/80593860/f4ed44cb-4c5b-4023-a2ec-01f963addf77)
