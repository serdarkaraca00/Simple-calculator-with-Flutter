import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';//matematik işlemi için

void main(){
  runApp(Calculator());//calculator classı çalışsın
}

class Calculator extends StatelessWidget {//stless diyince otomatik oluştur burayı.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//sağ üstteki debug yazısı kalktı.
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SimpleCalculator(),

    );
  }
}

class SimpleCalculator  extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {

  String equation = "0";//üstteki başta 0 olarak başlıyor.
  String result = "0";
  String expression = "";//flutter mat olayında değişiklik yapmak gerekiyo(x yerine * yazmak gibi.) bu değişikliği bu string üzerinden yapıyoruz.
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText){//buton basılınca yapılcaklar
    setState((){
      if(buttonText == "C"){//bastığım buton C ise içindekileri yap.
        equation = "0";//buna basınca hem alt hem üst sıfır oluyo
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      }

      else if(buttonText == "⌫"){//silme
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);//son harf dışındakileri alarak silmiş olduk
        if(equation == ""){//silince üstte bişey kalmayınca 0 olarak üstte yazılsın. böylece boş durmamış olur.
          equation = "0";
        }
      }
      else if(buttonText == "="){
        equationFontSize = 38.0;
        resultFontSize = 48.0;//"=" e basınca sonuç kısmı bir tık daha büyümüş oluyo

        expression = equation;
        expression = expression.replaceAll('×', '*');//flutter ın mat sisteminde x i * olarak çevirmek gerekli.
        expression = expression.replaceAll('÷', '/');


        try{//try catch yaptıkki eğer hata gelirse uygulama çökmesin ve hata mesajı verelim.
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        }catch(e){
          result = "Error";
        }
      }

      else{//sayılara yada işlemlere basarsam.
        if(equation == "0"){//ilk başta buraya girdik. eğer 0 dışında bişeye basarsam bir sonraki basışımda else e gircem. 0 girersem hala bu if e girmeye devam ederim.
          equationFontSize = 48.0;
          resultFontSize = 38.0;
          equation = buttonText;//bastığım buton yazısı ne ise o üstte yazılcak.
        }else{

          equation = equation + buttonText;//bastığım buton yazısı ne ise o stringde yana eklenir.
        }
      }

    });
  }

  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor){//buton yapmak için class oluşturduk. buton textini, boyutunu ve rengini aldık.
    return Container(
        height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
        color: buttonColor,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: BorderSide(
                  color: Colors.black,
                  width: 1,//butonlar arası mesafe
                  style: BorderStyle.solid,
                ),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(16.0),
            ),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 30.0,//butonlardaki text boyutu
              fontWeight: FontWeight.normal,
              color: Colors.white,//tuşların rengi
            ),
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(//bunu Scaffold yapınca ekran beyaz oldu.
      appBar: AppBar(title: Text('Simple Calculator')),// üst tarafta mavi kısım ve başlık
      body: Column(
        children: <Widget>[

          Container(//üst kısım için alan oluşturduk
            alignment: Alignment.centerRight,//üst sayıları sağa yaslamış olduk.
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),//padding ile ekranda belli bir konuma getirmiş olduk
            child: Text(equation, style: TextStyle(fontSize: equationFontSize),),
          ),

          Container(//sonuç kısmı için alan oluşturduk
            alignment: Alignment.centerRight,//sonucu sağa yaslamış olduk
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),//padding ile ekranda belli bir konuma getirmiş olduk
            child: Text(result, style: TextStyle(fontSize: resultFontSize),),
          ),
          Expanded(
            child: Divider(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(//ilk 3 sütun için alan
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          buildButton("C",1,Colors.red),
                          buildButton("⌫",1,Colors.orange),
                          buildButton("÷",1,Colors.green),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("7",1,Colors.blueGrey),
                          buildButton("8",1,Colors.blueGrey),
                          buildButton("9",1,Colors.blueGrey),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("4",1,Colors.blueGrey),
                          buildButton("5",1,Colors.blueGrey),
                          buildButton("6",1,Colors.blueGrey),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("1",1,Colors.blueGrey),
                          buildButton("2",1,Colors.blueGrey),
                          buildButton("3",1,Colors.blueGrey),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton(".",1,Colors.blueGrey),
                          buildButton("0",1,Colors.blueGrey),
                          buildButton("00",1,Colors.blueGrey),
                        ]
                    ),
                  ],
                ),
              ),

              Container(//en sağ sütun için alan
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          buildButton("×",1,Colors.green),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("-",1,Colors.green),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("+",1,Colors.green),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("=",2,Colors.blue),
                        ]
                    ),
                  ],
                ),
              )

            ],
          ),

        ],
      ),
    );
  }
}


