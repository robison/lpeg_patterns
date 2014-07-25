local lpeg = require "lpeg"

describe ( "LPEG Pattern Validation" , function()
	local lpeg = require "lpeg"
	local lpeg_patterns = require "lpeg_patterns"

	describe ( "Email Addresses" , function()
		local email = lpeg_patterns.email * lpeg.P(-1)
		it ( "Pass valid addresses" , function()
			assert.truthy ( email:match( "localpart@example.com" ) )
		end)
		it ( "Deny invalid addresses" , function()
			assert.falsy ( email:match( "not an address" ) )
		end)
		it("Handle unusual localpart",function()
			assert.truthy ( email:match "foo.bar@example.com" )
			assert.truthy ( email:match "foo+@example.com" )
			assert.truthy ( email:match "foo+bar@example.com" )
			assert.truthy ( email:match "!#$%&'*+-/=?^_`{}|~@example.com" )
			assert.truthy ( email:match [["quoted"@example.com]] )
			assert.truthy ( email:match [["quoted string"@example.com]] )
			assert.truthy ( email:match [["quoted@symbol"@example.com]] )
			assert.truthy ( email:match [=["very.(),:;<>[]\".VERY.\"very@\\ \"very\".unusual"@example.com]=] )
		end)
		it("Ignore invalid localpart",function()
			assert.falsy ( email:match "@example.com" )
			assert.falsy ( email:match ".@example.com" )
			assert.falsy ( email:match "foobar.@example.com" )
			assert.falsy ( email:match "@foo@example.com" )
			assert.falsy ( email:match "foo@bar@example.com" )
			assert.falsy ( email:match [[just"not"right@example.com]] ) -- quoted strings must be dot separated, or the only element making up the local-part
			assert.falsy ( email:match( "\127@example.com" ) )
		end)
		it("Handle unusual hosts",function()
			assert.truthy ( email:match "localpart@host_name" )
			assert.truthy ( email:match "localpart@[127.0.0.1]" )
			assert.truthy ( email:match "localpart@[IPv6:2001::d1]" )
			assert.truthy ( email:match "localpart@[::1]" )
		end)
		it("Handle comments",function()
			assert.truthy ( email:match "localpart@(comment)example.com" )
			assert.truthy ( email:match "localpart@example.com(comment)" )
		end)
	end)

	describe ( "URI" , function()
		local uri = lpeg_patterns.uri * lpeg.P(-1)
		it("Should match file urls", function()
			assert.truthy ( uri:match "file:///var/log/messages" )
			assert.truthy ( uri:match "file:///C:/Windows/" )
		end)
		it("Should match localhost", function()
			assert.truthy ( uri:match "localhost" )
			assert.truthy ( uri:match "localhost:8000" )
			assert.truthy ( uri:match "http://localhost:8000" )
		end)
	end)

	describe ( "Sane URI" , function()
		local sane_uri = lpeg_patterns.sane_uri
		it("Not match the empty string", function()
			assert.falsy ( sane_uri:match "" )
		end)
		it("Not match misc words", function()
			assert.falsy ( sane_uri:match "the quick fox jumped over the lazy dog." )
		end)
		it("Not match numbers", function()
			assert.falsy( sane_uri:match "123" )
			assert.falsy( sane_uri:match "17.3" )
			assert.falsy( sane_uri:match "17.3234" )
			assert.falsy( sane_uri:match "17.3234" )
		end)
	end)
end)
