<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/main.css">
<script src="scripts/main.js"></script>
<title>Asiakkaiden listaus</title>
<style>
.oikealle{
	text-align: right;
}
</style>
</head>
<body onkeydown="tutkiKey(event)">
	<table id="listaus">
		<thead>	
			<tr>
				<th colspan="5" class="oikealle"><span id="uusiAsiakas">Lisää uusi asiakas</span></th>
			</tr>
			<tr>
				<th colspan="3" class="oikealle">Hakusana:</th>
				<th><input type="text" id="hakusana"></th>
				<th><input type="button" id="hae" value="Hae" id="hakunappi" onclick="haeTiedot()"></th>
			</tr>		
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>	
				<th>&nbsp;</th>				
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
<script>
haeTiedot();
document.getElementById("hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä

function tutkiKey(event){
	if(event.keyCode==13){//Enter
		haeTiedot();
	}		
}
//Funktio tietojen hakemista varten
//GET   /asiakkaat/{hakusana}
function haeTiedot(){	
	document.getElementById("tbody").innerHTML = "";
	fetch("asiakkaat/" + document.getElementById("hakusana").value,{//Lähetetään kutsu backendiin
	      method: 'GET'
	    })
	.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json()	
	})
	.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
		var asiakkaat = responseJson.asiakkaat;	
		var htmlStr="";
		for(var i=0;i<asiakkaat.length;i++){			
      	htmlStr+="<tr>";
      	htmlStr+="<td>"+asiakkaat[i].etunimi+"</td>";
      	htmlStr+="<td>"+asiakkaat[i].sukunimi+"</td>";
      	htmlStr+="<td>"+asiakkaat[i].puhelin+"</td>";
      	htmlStr+="<td>"+asiakkaat[i].sposti+"</td>";  
      	htmlStr+="<td><a href='muutaasiakas.jsp?etunimi="+asiakkaat[i].etunimi+"'>Muuta</a>&nbsp;";
      	htmlStr+="<span class='poista' onclick=poista('"+asiakkaat[i].etunimi+"')>Poista</span></td>";
      	htmlStr+="</tr>";        	
		}
		document.getElementById("tbody").innerHTML = htmlStr;		
	})	
}

//Funktio tietojen poistamista varten. Kutsutaan backin DELETE-metodia ja välitetään poistettavan tiedon id. 
//DELETE /asiakkaat/id
function poista(etunimi){
	if(confirm("Poista asiakas" + etunimi +"?")){	
		fetch("asiakkaat/"+ etunimi,{//Lähetetään kutsu backendiin
		      method: 'DELETE'		      	      
		    })
		.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()
		})
		.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Asiakkaan poisto epäonnistui.";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmo").innerHTML="Asiakkaan " + etunimi +" poisto onnistui.";
				haeTiedot();        	
			}	
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
		})		
	}	
}
</script>
</body>
</html>