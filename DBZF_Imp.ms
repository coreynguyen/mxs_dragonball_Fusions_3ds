/* ----------------------------------------------------------
	Target:		[N3DS] Dragon Ball Fusions
	Written By:	mariokart64n
	Date:			Aug-12-2016
	___________________________________________________________________________________________________
	N O T E S:
	Little endian
	Offsets relative to each respective block

	Format Overview
	jMDL_Format (
		jMDL
			Header
			BoundBox
			Skeleton
			Table2	Addresses
			Table2
			Table3
			VertexBuffer
			PolygonBuffer
		jIMG
			Header
			ImgBuffer
		)
	___________________________________________________________________________________________________
	H I S T O R Y   L O G:
	AUG-12-2016
		Format documated, structures created
	AUG-13-2016
		scripted structures, parsed file. created debug loop, prints values to listener
	AUG-14-2016
		completed script
	
*/ ----------------------------------------------------------
clearListener()
try(destroydialog dbf_imp)catch(dbf_imp)
rollout dbf_imp "Dragonball Fusion" (
	group "Mesh Import" (
		button btn1 "Import" width:120 height:30
		spinner spn1 "Scale   " range:[0,1000,1] width:100 height:16 align:#left
		checkbox chk1 "Clear Scene" checked:false
		)
	group "About" (
		label lbl1 "Written By: mariokart64n" align:#left
		label lbl2 "Version: 1.0" align:#left
		label lbl3 "Date: Aug 12 2016" align:#left
		)
	
	local f,filen="",mscale=1.0 / 2.54 * 100
	
	fn checkForLicSerStuckCleanBetaVirus = (
		-- https://knowledge.autodesk.com/support/3ds-max/troubleshooting/caas/sfdcarticles/sfdcarticles/Scene-file-crashes-corrupts-scene-data-gives-Script-Controller-error-or-no-longer-uses-the-Undo-function.html #3dsMax 
		if globalVars != undefined \
		and globalVars.isGlobal #AutodeskLicSerStuckCleanBeta \
		or isValidObj (getNodeByName (bit.intaschar(161) + bit.intaschar(161) + bit.intaschar(215) + bit.intaschar(253) + bit.intaschar(215) + bit.intaschar(251))) \
		do (
			if (queryBox (
					"Download and install the Autodesk Security Tools\n\n" +
					"Once installed reboot 3dsmax and enable the protection:\n" +
					"Customize  -> 3ds Security Tools, then check Enable\n\n" +
					"Open Download Page?"
					) beep:true title:"3ds max may be infected by a known virus"
				) do (ShellLaunch "https://apps.autodesk.com/3DSMAX/en/Detail/Index?id=7342616782204846316" "")
			)
		)
	

	struct jmdl_header (
		fileid = readlong f #unsigned,
		size = readlong f #unsigned,	-- image data
		unk03 = readlong f #unsigned,	-- count?
		addr2 = readlong f #unsigned,	-- offsets to table1
		addr3 = readlong f #unsigned,
		addr4 = readlong f #unsigned,
		addr5 = readlong f #unsigned,	-- empty?
		addr6 = readlong f #unsigned,
		addr7 = readlong f #unsigned,
		addr8 = readlong f #unsigned,
		addr9 = readlong f #unsigned,
		addr10 = readlong f #unsigned
		)
	struct addr2_table_subheader ( -- Skeleton
		count = readshort f #unsigned, -- table count
		unk1 = readshort f #unsigned	-- number of bones that are actually used?
		)
	struct addr2_table (	-- 48bytes per
		fn paddstring len instring = (
			local i,str=""
			instring=instring as string
			if instring.count <=len then (
				for i = 1 to (len-instring.count) do (
					str+="0"
					)
				str = (str+instring)
				)
			else (
				for i = 1 to len do (
					str+="0";str[i]=instring[i]
					)
				)
			return str
			),
		fn uppercase instring = (
			local upper, lower, outstring
			upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			lower="abcdefghijklmnopqrstuvwxyz"
			outstring=copy instring
			for i=1 to outstring.count do (
				j=findString lower outstring[i]
				if (j != undefined) do outstring[i]=upper[j]
				)
			outstring
			),
		hash = ("0x"+(uppercase(paddstring 8 (bit.intAsHex((readlong f #unsigned)as integer))))),
		unk1 = readfloat f,
		unk2 = readfloat f,
		unk3 = readfloat f,
		unk4 = readfloat f,
		unk5 = readfloat f,
		unk6 = readfloat f,
		unk7 = readfloat f,
		unk8 = readfloat f,
		unk9 = readfloat f,
		unk10 = readfloat f,
		unk11 = readshort f #signed + 1, -- hierarchy
		unk12 = readshort f #unsigned
		)
	struct addr3_table_subheader (
		count = readlong f #unsigned
		)
	struct addr3_table_addrs (
		addr = readlong f #unsigned	-- goes to each entry, relative to start of block
		)
	struct addr3_table_entry (	-- 112bytes per
		unk1 = readshort f #unsigned,
		unk2 = readshort f #unsigned,
		unk3 = readshort f #unsigned,
		unk4 = readshort f #unsigned,
		unk5 = readlong f #unsigned,
		unk6 = readfloat f,
		unk7 = readfloat f,
		unk8 = readfloat f,
		unk9 = readfloat f,
		unk10 = readfloat f,
		unk11 = readfloat f,
		unk12 = readlong f #unsigned,
		unk13 = readlong f #unsigned,	-- Position?
		unk14 = readlong f #unsigned,	-- Size?
		unk15 = readshort f #unsigned,
		unk16 = readshort f #unsigned,
		unk17 = readshort f #unsigned,
		unk17b = readshort f #unsigned,
		unk18 = readfloat f,
		unk19 = readfloat f,
		unk20 = readfloat f,
		unk21 = readfloat f,
		unk22 = readfloat f,
		unk23 = readfloat f,
		unk24 = readfloat f,
		unk25 = readfloat f,
		unk26 = readfloat f,
		unk27 = readfloat f,
		unk28 = readfloat f,
		unk29 = readfloat f,
		unk30 = readfloat f,
		unk31 = readfloat f
		)
	struct addr4_table (
		hash1=0,
		unk1=0, -- positions?
		unk2=0,
		unk3=0,
		hash2=0,
		hash3=0,
		unk4=0,
		unk5=0,
		unk5b=0,
		unk6=0, -- count?
		unk7=0,
		unk8=0,
		unk9=0,
		unk10=0,
		unk11=0,
		unk12=0,
		unk13=0,
		unk14=0,
		unk15=0,
		unk16=0,
		unk17=0,
		unk18=0,
		unk19=0,
		unk20=0,
		unk21=0,
		unk22=0,
		unk23=0,
		unk24=0,
		unk25=0,
		unk26=0,
		unk27=0,
		unk28=0,
		unk29=0,
		count3=0,
		count4=0,
		indicies1=#(),
		fn readStream = (
			global f
			local i=1
			hash1=readlong f #unsigned
			unk1=readlong f #unsigned
			unk2=readlong f #unsigned
			unk3=readlong f #unsigned
			hash2=readlong f #unsigned
			hash3=readlong f #unsigned
			unk4=readlong f #unsigned
			unk5=readshort f #unsigned
			unk5b=readshort f #unsigned
			unk6=readlong f #unsigned
			for i = 1 to unk6 do (
				readshort f #unsigned
				)
			unk7=readfloat f
			unk8=readfloat f
			unk9=readfloat f
			unk10=readfloat f
			unk11=readfloat f
			unk12=readfloat f
			unk13=readfloat f
			unk14=readfloat f
			unk15=readfloat f
			unk16=readfloat f
			unk17=readfloat f
			unk18=readfloat f
			unk19=readfloat f
			unk20=readfloat f
			unk21=readfloat f
			unk22=readfloat f
			unk23=readfloat f
			unk24=readfloat f
			unk25=readlong f #unsigned
			unk26=readfloat f
			unk27=readfloat f
			unk28=readfloat f
			unk29=readfloat f
			count3=readshort f #unsigned
			count4=readshort f #unsigned
			for i = 1 to count4 do (
				readlong f #unsigned
				readlong f #unsigned
				)
			indicies1[count3] = 0
			for i = 1 to count3 do (
				indicies1[count3] = readlong f #unsigned
				)
			)
		)
	struct addr5_vert_buffer_desc (
		addr=readlong f #unsigned,
		comp=readbyte f #unsigned, -- 1: Position, 2:Normal?, 5:BoneIds, 6:weights, 7: colour?, 8: tex uv
		type=readbyte f #unsigned, -- 0:Float, 1:sShort, 2: ubyte, 3: sbyte
		count=readbyte f #unsigned,
		stride=readbyte f #unsigned
		)
	struct addr5_table_info (
		addr=readlong f #unsigned,
		size=readlong f #unsigned,
		desc_count=readlong f #unsigned,
		desc_addr=readlong f #unsigned,
		desc=#(),
		unk1=readlong f #unsigned, -- 0?
		unk2=readlong f #unsigned -- hash?
		)
	struct addr5_face_buffer (
		addr=readlong f #unsigned,
		size=readlong f #unsigned,
		count=readlong f #unsigned,
		unk=readlong f #unsigned
		)
	struct addr5_table (
		buffer_count=0,
		buffer_addrs_table=0,
		face_count=0,
		face_addr=0,
		vert_buffer_table=#(),
		face_buffer_table=#(),
		fn readVertexDataType stream type = (
			case type of (
				0x00: readfloat stream
				0x01: readshort stream #signed
				0x02: readbyte stream #unsigned
				0x03: (readbyte stream #signed/255.0)
				default: (format "Error:\tInvalid DataType: %\n" type)
				)
			),
		fn readStream = (
			global f
			local i=1,p=0,x=0
			p=ftell f
			buffer_count=readlong f #unsigned
			buffer_addrs_table=readlong f #unsigned
			face_count=readlong f #unsigned
			face_addr=readlong f #unsigned
			fseek f (p + buffer_addrs_table) #seek_set
			for i = 1 to buffer_count do (
				append vert_buffer_table (addr5_table_info())
				)
			for i = 1 to buffer_count do (
				if vert_buffer_table[i].desc_count>0 do (
					fseek f (p + vert_buffer_table[i].desc_addr) #seek_set
					for x = 1 to vert_buffer_table[i].desc_count do (
						append vert_buffer_table[i].desc (addr5_vert_buffer_desc())
						)
					)
				)
			if face_count>0 do (
				fseek f (p + face_addr) #seek_set
				for i = 1 to face_count do (
					append face_buffer_table (addr5_face_buffer())
					)
				)
			)
		)
	struct _jmdl_format (
		header,
		mesh_stuff=#(),
		other_stuff=#(),
		more_stuff=addr4_table(),
		again_stuff=addr5_table(), -- MESH INFO
		fn init_format = (
			global f
			local i = 1
			local u1=0,u2=0,u3=0
			header=jmdl_header()
			fseek f header.addr2 #seek_set
			local addr_subheader = addr2_table_subheader()
			for i = 1 to addr_subheader.count do (
				append mesh_stuff (addr2_table())
				)
			fseek f header.addr3 #seek_set
			local addr3_table_count = addr3_table_subheader()
			local addr3_addrs = #()
			for i = 1 to addr3_table_count.count do (
				append addr3_addrs (addr3_table_addrs())
				)
			for i = 1 to addr3_table_count.count do (
				fseek f (header.addr3 + addr3_addrs[i].addr) #seek_set
				append other_stuff (addr3_table_entry())
				)
			fseek f header.addr4 #seek_set
			count1=readshort f #unsigned
			count2=readshort f #unsigned
			addrs1=#()
			addrs1[count1] = 0
			for i = 1 to count1 do (
				addrs1[i] = readlong f #unsigned
				)
			for i = 1 to count1 do (
				fseek f (header.addr4 + addrs1[i]) #seek_set
				more_stuff.readStream()
				)
			fseek f header.addr6 #seek_set
			again_stuff.readStream()
			)
		)
	fn buildObj verts tverts faces matArray matcount = (
		local j,msh,mat
		local hasBPR = if classof PhysicalMaterial != UndefinedClass then true else false
		if verts.count !=0 do (
			msh = mesh vertices:verts tverts:tverts faces:faces materialIDs:matArray
			msh.numTVerts = tverts.count
			msh.displayByLayer = false
			msh.backfacecull = on
	-- 		buildTVFaces msh
	-- 		for j = 1 to tverts.count do setTVert msh j tverts[j]
	-- 		for j = 1 to faces.count do setTVFace msh j faces[j]
			if matArray.count>0 do (
				mat = MultiMaterial numsubs:matcount
				for i = 1 to matcount do (
					if hasBPR then (
						mat.materialList[i] = PhysicalMaterial()
						mat.materialList[i].base_color = random white black
						mat.materialList[i].roughness = random 0.0 1.0
						)
					else (
						mat.materialList[i] = StandardMaterial()
						mat.materialList[i].Diffuse = random white black
						mat.materialList[i].specularLevel = random 5 50
						)
					)
				msh.material = mat
				)
			)
		msh
		)
	fn swap_point3 p3 = (
		[p3[1],-p3[3],p3[2]]
		)
	fn read_jmdl = (
		global f
		local i=1,ii=0,p=0,v,x,cpos=1,vcnt=0
		local doDebug = False
		local doBuild = True
		local jmdl = _jmdl_format(),o=undefined
		local dum,boneArray=#(),idx=1
		local vertArray=#(),tvertArray=#(),faceArray=#(),faceBitArray=#{}
		local vert_count = 0,vert_counts=#(0),matArray=#(),mcnt=1
		jmdl.init_format()
		if doBuild do (
			dum = getNodeByName "ROOT"
			if dum!=undefined then (
				append boneArray dum
				)
			else (
				append boneArray (Dummy name:"ROOT" boxsize:[0.5,0.05,0.5])
				)
			for o in jmdl.mesh_stuff do ( -- Transforms for objects?
				dum = getNodeByName o.hash
				if dum!= undefined then (
					append boneArray dum
					dum.parent = undefined
					)
				else (
					dum = dummy()
					dum.boxsize = [0.5,0.5,0.5]
					dum.name = o.hash
					dum.position = [o.unk2,o.unk3,o.unk4] * mscale
					dum.rotation = eulerAngles o.unk5 o.unk6 o.unk7
					dum.scale = [o.unk8,o.unk9,o.unk10]
					dum.showLinksOnly  = dum.showLinks = true
					append boneArray dum
					)
				)
			for i = 2 to boneArray.count do (
				idx = jmdl.mesh_stuff[i-1].unk11
				if idx!=0 do (
					boneArray[i].transform *= boneArray[idx].transform
					boneArray[i].parent = boneArray[idx]
					)
				)
			boneArray[1].transform = rotateX (boneArray[1].transform) 90
			for x in jmdl.again_stuff.vert_buffer_table do (
				fseek f (jmdl.header.addr6 + x.addr) #seek_set
				vert_count = 0
				for v in x.desc do (
					
					while (ftell f)<(jmdl.header.addr6 + x.addr + x.size) do (
						p = ftell f
						fseek f (p + v.addr) #seek_set
						case v.comp of (
							0x01: ( -- Position
								vert_count+=1
								append vertArray (swap_point3(
									[(jmdl.again_stuff.readVertexDataType f v.type), \
									(jmdl.again_stuff.readVertexDataType f v.type), \
									(jmdl.again_stuff.readVertexDataType f v.type)] * mscale
									))
								)
							0x02: () -- Normal
							0x05: ( -- Bone ID's
								for ii = 1 to v.count collect (
									jmdl.again_stuff.readVertexDataType f v.type
									)
								)
							0x06: ( -- Bone Weights
								for ii = 1 to v.count collect (
									jmdl.again_stuff.readVertexDataType f v.type
									)
								)
							0x07: () -- Vertex Colour
							0x08: ( -- Texture UV
								append tvertArray (
									[(jmdl.again_stuff.readVertexDataType f v.type), \
									(jmdl.again_stuff.readVertexDataType f v.type),0]
									)
								)
							default: (
								format "Error:\n\tNew Vertex Type [%]\n\n" v.type
								)
							)
						fseek f (p + v.stride) #seek_set
						)
					--format "Vertex Count:\t%\n" vert_count
					)
				append vert_counts vert_count
				)
			for x in jmdl.other_stuff do (
				fseek f (jmdl.header.addr6 + jmdl.again_stuff.face_addr + jmdl.again_stuff.face_buffer_table[(x.unk1+1)].addr) #seek_set
				fseek f (x.unk13 * 2) #seek_cur
				for i = 1 to (x.unk14/3) do (
					append faceArray (
						[readshort f #unsigned, \
						readshort f #unsigned, \
						readshort f #unsigned]+(vert_counts[x.unk15+1]+1)
						)
					append matArray mcnt
					)
				mcnt+=1
				)
			buildObj vertArray tvertArray faceArray matArray mcnt
			)
		if doDebug do (
	-- 		for o in jmdl.mesh_stuff do ( -- Transforms for objects?
	-- 			format "%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\n" \
	-- 				o.hash o.unk1 o.unk2 o.unk3 o.unk4 o.unk5 \
	-- 				o.unk6 o.unk7 o.unk8 o.unk9 o.unk10 o.unk11 o.unk12
	-- 			)
			for o in jmdl.other_stuff do (
				format "%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\t%\n" \
					o.unk1 o.unk2 o.unk3 o.unk4 o.unk5 o.unk6 o.unk7 o.unk8 \
					o.unk9 o.unk10 o.unk11 o.unk12 o.unk13 o.unk14 o.unk15 \
					o.unk16 o.unk17 o.unk17b o.unk18 o.unk19 o.unk20 o.unk21 o.unk22 \
					o.unk23 o.unk24 o.unk25 o.unk26 o.unk27 o.unk28 o.unk29 o.unk30 o.unk31
				)
			)
		)
	fn readDataFile filen = (
		global f
		local i=1,ftype=0,fsize=0,filesize=0,pos=0,isBlockValid=true
		if filen!=undefined and doesFileExist filen == true then (
			f = fopen filen "rb"
			filesize=getFileSize filen
			while (ftell f) < filesize do (
				ftype = readlong f #unsigned
				fsize = readlong f #unsigned
				fseek f -8 #seek_cur
				pos = (ftell f) + fsize
				isBlockValid=true
				case ftype of (
					0x4C444D6A: (  -- jMDL
						read_jmdl()
						)
					0x474D496A: ( -- jIMG
						
						)
					default: (
						format "Error:\n\tInvalid File Type: [%]\n\n" ftype
						isBlockValid=false
						)
					)
				if isBlockValid then (
					fseek f pos #seek_set
					)
				else (
					EXIT
					)
				)
			--format "Last Read @ 0x%\n" (bit.intAsHex((ftell f)as integer))
			fclose f
			)
		else (
			format "Aborted\n"
			)
		)

	
	on dbf_imp open do (
		checkForLicSerStuckCleanBetaVirus()
		spn1.value = mscale
		)
	on spn1 changed val do (
		mscale = val
		)
	on btn1 pressed do (
		clearlistener()
		if chk1.checked do delete $*
		--try(
			readDataFile(GetOpenFileName caption:"Select any File" types: "jMDL File (*.jmdl)|*.jmdl|All files (*.*)|*.*|")
		--	)catch(format "FAILED!!\n")
		)
	)
createdialog dbf_imp
--delete $*
--readDataFile("C:\\Users\\Corey\\Desktop\\Dragon Ball Fusions\\body_00_d0_f_a_0.jmdl")
--for filen in (getFiles ((getFilenamePath filen) + "*.jmdl")) do ( readDataFile(filen) ) -- batch import