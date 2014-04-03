# Some useful Hebrew manipulation routines
#
# @author Asaf Bartov <asaf.bartov@gmail.com>
#

# codepoints for CP1255 nikkud
NIKKUD_CP1255 = [192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 209, 210]
#NIKKUD_CP1255 = ["\xc0".force_encoding('windows-1255'), "\xc1".force_encoding('windows-1255'), "\xc2".force_encoding('windows-1255'), "\xc3".force_encoding('windows-1255'), "\xc4".force_encoding('windows-1255'), "\xc5".force_encoding('windows-1255'), "\xc6".force_encoding('windows-1255'), "\xc7".force_encoding('windows-1255'), "\xc8".force_encoding('windows-1255'), "\xc9".force_encoding('windows-1255'), "\xcb".force_encoding('windows-1255'), "\xcc".force_encoding('windows-1255'), "\xd1".force_encoding('windows-1255'), "\xd2".force_encoding('windows-1255')] # wow, this is fugly.  Is there a neater way to specify CP1255 literal?
NIKKUD_UTF8 = [0x05b0, 0x05b1, 0x05b2, 0x05b3, 0x05b4, 0x05b5, 0x05b6, 0x05b7, 0x05b8, 0x05b9, 0x05bb, 0x05bc, 0x05bd, 0x05bf, 0x05c1, 0x05c2]
#NIKKUD_UTF8 = ["\u05b0", "\u05b1", "\u05b2", "\u05b3", "\u05b4", "\u05b5", "\u05b6", "\u05b7", "\u05b8", "\u05b9", "\u05bb", "\u05bc", "\u05c1", "\u05c2"]
# TODO: Mac encoding

FIANLS_CP1255 = ["\xea".force_encoding('windows-1255'), "\xed".force_encoding('windows-1255'), "\xef".force_encoding('windows-1255'), "\xf3".force_encoding('windows-1255'), "\xf5".force_encoding('windows-1255')]

FINALS_UTF8 = ["\u05da", "\u05dd", "\u05df", "\u05e3", "\u05e5"]
HEB_UTF8_START = 1424
HEB_UTF8_END = 1535

# extend String class
class String
  # this will return the string, stripped of any Hebrew nikkud characters
  def strip_nikkud
    case self.encoding
    when Encoding::UTF_8
      strip_nikkud_utf8
    when Encoding::WINDOWS_1255 || Encoding::CP1255
      strip_nikkud_cp1255
    end
  end
  def strip_nikkud_cp1255
    target = ''.force_encoding('windows-1255')
    self.each_codepoint {|cp|
      unless self.class.is_codepoint_nikkud_cp1255(cp)
        target += cp.chr(Encoding::CP1255) # is there a neater way?
      end
    }
    return target
  end
  def strip_nikkud_utf8
    target = ''
    self.each_codepoint {|cp|
      unless self.class.is_codepoint_nikkud_utf8(cp)
        target += cp.chr(Encoding::UTF_8)
      end
    }
    return target
  end
  # this will return true if the string contains any Hebrew character (short circuit)
  def any_hebrew?
    case self.encoding
    when Encoding::UTF_8
      self.each_codepoint {|cp| return true if is_hebrew_codepoint_utf8(cp) }
      return false
    when Encoding::WINDOWS_1255 || Encoding::CP1255
      self.each_codepoint {|cp| return true if is_hebrew_codepoint_cp1255(cp) }
      return false
    else
      return false
    end
  end
  def is_hebrew_codepoint_cp1255(cp)
    return ((cp > 191 && cp < 202) or [203, 204, 209, 210].include?(cp))
  end
  def is_hebrew_codepoint_utf8(cp)
    return (cp >= HEB_UTF8_START && cp <= HEB_UTF8_END)
  end
  
  # TODO: add strip_nikkud!
  
  # this will return true if the parameter is a nikkud character
  def is_nikkud(c)
    self.class.is_nikkud_by_encoding(c, self.encoding) # delegate to class method based on instance encoding
  end

  def self.is_codepoint_nikkud_cp1255(cp)
    return ((cp > 191 && cp < 205) or [209, 210].include?(cp))
    #NIKKUD_CP1255.include?(cp) # cleaner, but much slower
  end
  def self.is_codepoint_nikkud_utf8(cp)
    return ((cp > 0x05af && cp < 0x05ba) or [0x05bb, 0x05bc, 0x05c1, 0x05c2].include?(cp))
    #NIKKUD_UTF8.include?(cp) # cleaner, but much slower
  end
  # this will return true if the first parameter is a nikkud character in the encoding of the second parameter
  def self.is_nikkud_by_encoding(c, encoding)
    case encoding
    when Encoding::UTF_8
      self.is_codepoint_nikkud_utf8(c.codepoints.first)
    when Encoding::WINDOWS_1255 || Encoding::CP1255
      self.is_codepoint_nikkud_cp1255(c.codepoints.first)
    # TODO: add Mac encoding?
    end
  end
  # this will return true if the first parameter is a final letter in the encoding of the second parameter
  def self.is_final_by_encoding(c, encoding)
    case encoding
    when Encoding::UTF_8
      FIANLS_UTF8.include?(c)
    when Encoding::WINDOWS_1255 || Encoding::CP1255
      FINALS_CP1255.include?(c)
    end
  end
end
