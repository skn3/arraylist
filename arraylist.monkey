Strict

'version 5
' - added RequireSize() which lets you pre resize the list ahead of adding content
'version 4
' - fixed Contains method missing return valu
'version 3
' - fixed enumator
'version 2
' - fixed insert array resize bug
' - standerdized insert param order to match monkey stack
'version 1
' - first release

Class ArrayList<T>
	Field data:T[]
	Field count:Int
	
	'constructor/destructor
	Method New(count:Int = 0)
		' --- create array list with predetermined sized empty array ---
		data = New T[count]
	End

	'api
	Method Equals:Bool( lhs:T,rhs:T )
		Return lhs=rhs
	End
	
	Method Compare:Bool(lhs:T, rhs:T)
		Error "Unable to compare items"
	End
	
	Method Clear:Void()
		count = 0
	End

	Method Length:Int() Property
		Return count
	End

	Method IsEmpty:Bool()
		Return count = 0
	End
	
	Method Contains:Bool( item:T )
		For Local i:= 0 Until count
			If Equals( data[i],item ) Return True
		Next
		Return False
	End Method
	
	Method AddLast:Void(item:T)
		' --- add to end of list ---
		'resize
		If count = data.Length data = data.Resize(count * 2 + 10)
		
		'set
		data[count] = item
		count += 1
	End
	
	Method AddFirst:Void(item:T)
		' --- add item at start of list ---
		Insert(0, item)
	End

	Method RemoveFirst:T()
		' --- remove and return first item ---
		If count = 0 Return Null
		
		'get first item so we can return it
		Local item:T = data[0]
		
		'waht to do?
		If count > 1
			'shift data, this will also null the old first item
			For Local index:= 1 Until count
				data[index - 1] = data[index]
			Next
			
			'null last one as this is now gone
			data[count - 1] = Null
		Else
			'need to null first item
			data[0] = Null
		EndIf
		
		'return first item
		Return item
	End
	
	Method RemoveLast:T()
		' --- remove and return last item ---
		If count = 0 Return Null
		
		'get last item
		Local item:= data[count - 1]
		
		'null and remove
		count -= 1
		data[count] = Null
		
		'return last item
		Return item
	End
	
	Method First:T()
		' --- get first item ---
		Return data[0]
	End
	
	Method Last:T()
		' --- get last item ---
		Return data[count - 1]
	End
	
	Method Insert:Void(index:Int, item:T)
		' --- insert item within the list ---
		'resize
		If index > data.Length data = data.Resize(index * 2 + 10)
		
		'shift data
		For Local index:= count Until index Step - 1
			data[index] = data[index - 1]
		Next
		
		'insert new
		data[index] = item
		count += 1
	End

	Method Remove:T(index:Int)
		' --- remove item at index ---
		'skip
		If index < 0 or index >= count Return Null
		
		'get old item
		Local item:T = data[index]
		
		'shift data
		For Local index:= index Until count - 1
			data[index] = data[index + 1]
		Next
		
		'null last one otherwise it doesn't count as gone
		data[count - 1] = Null
		
		'decrease count
		count -= 1
		
		'return old item
		Return item
	End
	
	Method Remove:Void(item:T)
		' --- remove all instances of item ---
		Local i:Int
		While i < count
			If Not Equals( data[i],item )
				i+=1
				Continue
			Endif
			Local b:= i
			Local e:= i + 1
			While e < count And Equals(data[e], item)
				e+=1
			Wend
			While e < count
				data[b]=data[e]
				b+=1
				e+=1
			Wend
			count -= e - b
			i+=1
		Wend
	End
	
	Method ToArray:T[] ()
		' --- convert this to an array ---
		Local newArray:= New T[count]
		For Local index:= 0 Until count
			newArray[index] = data[index]
		Next
		Return newArray
	End
	
	Method FillArray:Int(destination:T[])
		' --- fill the given array with the data ---
		'skip
		If destination.Length = 0 or count = 0 Return 0
		
		'get number of items to fill
		Local total:Int = count
		If destination.Length < count total = destination.Length
		
		'copy
		For Local index:= 0 Until total
			destination[index] = data[index]
		Next
		
		'return number of items copied
		Return total
	End
	
	Method ObjectEnumerator:ArrayListEnumerator<T>()
		Return New ArrayListEnumerator<T>(Self)
	End
	
	Method RequireSize:Void(count:Int)
		' --- resizes ---
		'force the data array to be at least speciffic size
		If data.Length < count data = data.Resize(count)
	End
End

Class ArrayListEnumerator<T>
	Field arrayList:ArrayList < T >
	Field index:Int
	
	Method New(arrayList:ArrayList < T >)
		Self.arrayList = arrayList
	End

	Method HasNext:Bool()
		Return index < arrayList.count
	End

	Method NextObject:T()
		index+=1
		Return arrayList.data[index - 1]
	End
End