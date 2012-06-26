require 'java'
require 'itextpdf-5.3.0.jar'
require 'batik-1.7/batik.jar'

java_import java.awt.Graphics2D
java_import java.io.FileOutputStream

# Batik
java_import org.apache.batik.bridge.BridgeContext
java_import org.apache.batik.bridge.DocumentLoader
java_import org.apache.batik.bridge.GVTBuilder
java_import org.apache.batik.bridge.UserAgent
java_import org.apache.batik.bridge.UserAgentAdapter
java_import org.apache.batik.dom.svg.SAXSVGDocumentFactory
java_import org.apache.batik.gvt.GraphicsNode
java_import org.apache.batik.util.XMLResourceDescriptor
java_import org.w3c.dom.svg.SVGDocument

# iText
java_import com.itextpdf.awt.PdfGraphics2D
java_import com.itextpdf.text.Document
java_import com.itextpdf.text.DocumentException
java_import com.itextpdf.text.Rectangle
java_import com.itextpdf.text.pdf.PdfContentByte
java_import com.itextpdf.text.pdf.PdfTemplate
java_import com.itextpdf.text.pdf.PdfWriter
java_import com.itextpdf.text.pdf.SpotColor
java_import com.itextpdf.text.pdf.PdfSpotColor
java_import com.itextpdf.text.pdf.CMYKColor

class SvgToPdf
    
  def initialize
    parser = XMLResourceDescriptor.getXMLParserClassName
    @factory = SAXSVGDocumentFactory.new(parser)
    user_agent = UserAgentAdapter.new
    loader = DocumentLoader.new(user_agent)
    @ctx = BridgeContext.new(user_agent, loader)
    @ctx.setDynamicState BridgeContext.const_get("DYNAMIC")
    @builder = GVTBuilder.new

    path = '/Users/philmcclure/code/jruby_itext'
    create_pdf("#{path}/shape.svg", "#{path}/shape.pdf")
  end

  def drawSvg(template, resource)
    g2d = PdfGraphics2D.new(template, 856.578, 757.972)
    svg = @factory.createSVGDocument(java.io.File.new(resource).toURL().toString())
    map_graphics = @builder.build(@ctx, svg)
    map_graphics.paint(g2d)
    g2d.dispose
  end

  def create_pdf(input_file, output_file)
    rect = Rectangle.new(856.578, 757.972)
    document = Document.new(rect)
    writer = PdfWriter.getInstance(document, FileOutputStream.new(output_file))
    document.open

    # Layer 1
    #cb = writer.getDirectContent()
    #cb.saveState
    #template = cb.createTemplate(856.578, 757.972)
    #drawSvg(template, input_file)
    #cb.addTemplate(template, 0, 0)
    #cb.restoreState

    # Layer 2
    cb2 = writer.getDirectContent()
    #cb2.saveState
    #template = cb2.createTemplate(856.578, 757.972)
    #drawSvg(template, input_file)
    #cb2.addTemplate(template, 50, 50)
    #cb2.restoreState

    psc_cmyk = PdfSpotColor.new "iTextSpotColorCMYK", CMYKColor.new(0.3, 0.9, 0.3, 0.1)
    #colorRectangle cb2, SpotColor.new(psc_cmyk, 0.25), 470, 770, 36, 36
    cb2.saveState
    cb2.setColorFill(SpotColor.new(psc_cmyk, 0.25))
    cb2.rectangle(470, 770, 36, 36)
    cb2.fillStroke
    cb2.restoreState
 
    document.close
  end

end

