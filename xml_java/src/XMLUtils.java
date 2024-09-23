import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;


/**
 * Some handy functions for XML Processing
 * @author albert
 *
 */
public class XMLUtils {

	/**
	 * @see #xPathResAsString(Node, String, boolean)
	 */
	public static String xPathResAsString(Node n, String query)
			throws XPathExpressionException, ParserConfigurationException, TransformerException {
		return xPathResAsString(n, query, false);
	}

	/**
	 * 
	 * @param n The node on which the query is applied on (mostly the whole document)
	 * @param query the XPath Query String
	 * @param number is the output a number or an XML tree
	 * @return the result of the query based on <i>number</i>
	 */
	public static String xPathResAsString(Node n, String query, boolean number)
			throws XPathExpressionException, ParserConfigurationException, TransformerException {
		XPathFactory factory = XPathFactory.newInstance();
		XPath xpath = factory.newXPath();
		XPathExpression expr = xpath.compile(query);

		if (number) {
			return expr.evaluate(n, XPathConstants.NUMBER).toString();
		}

		NodeList result = (NodeList) expr.evaluate(n, XPathConstants.NODESET);

		Document doc = emptyDoc();
		Element root = doc.createElement("results");
		doc.appendChild(root);

		for (int i = 0; i < result.getLength(); i++) {
			Node act = result.item(i);

			Element res = doc.createElement("result");
			root.appendChild(res);
			if (act.getNodeType() == Node.ATTRIBUTE_NODE) {
				Element item = doc.createElement("item");
				res.appendChild(item);
				item.appendChild(doc.createTextNode(act.getTextContent()));
			} else {
				res.appendChild(doc.importNode(act, true));
			}
		}
		return asString(doc);

	}

	/**
	 * Create an empty doc for further processing
	 * @return
	 * @throws ParserConfigurationException
	 */
	public static Document emptyDoc() throws ParserConfigurationException {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		return builder.newDocument();
	}

	/**
	 * Parse the content of a file and return as XML Document for further processing
	 * @param fPath The full path of the file to be read
	 * @return
	 */
	public static Document readXML(String fPath) throws ParserConfigurationException, SAXException, IOException {
		DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
		return docBuilder.parse(new File(fPath));
	}

	/**
	 * Transform an XML node to String for output
	 */
	public static String asString(Node n) throws TransformerException {
		TransformerFactory transfac = TransformerFactory.newInstance();
		Transformer trans = transfac.newTransformer();
		trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
		trans.setOutputProperty(OutputKeys.INDENT, "yes");
		trans.setOutputProperty(OutputKeys.STANDALONE, "yes");
		trans.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "5"); // indent is 0 by default
		// create string from xml tree
		StringWriter sw = new StringWriter();
		StreamResult result = new StreamResult(sw);
		DOMSource source = new DOMSource(n);
		trans.transform(source, result);
		return sw.toString();
	}

	/**
	 * Take an XML String and perform and XSLT transformation
	 * @param xmlString XML as String
	 * @param xslPath path to the XSL-file
	 * @return the (HTML) output as String
	 */
	public static String xslTransformFromString(String xmlString, String xslPath)
			throws FileNotFoundException {
		String res = "";
		try {

			TransformerFactory tFactory = TransformerFactory.newInstance();
			Transformer transformer = tFactory.newTransformer(new StreamSource(xslPath));

			StreamSource xmlSource = new StreamSource(new StringReader(xmlString));
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			transformer.transform(xmlSource, new StreamResult(baos));

			res = baos.toString();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return res;

	}

	/**
	 * Perform an XSL-transformation
	 * 
	 * @param xmlPath path to the XML-file
	 * @param xslPath path to the XSL-file
	 * @param outPath path to the HTML-file to be written
	 */
	public static void xslTransform(String xmlPath, String xslPath, String outPath) throws FileNotFoundException {

		String res = "";
		try {

			TransformerFactory tFactory = TransformerFactory.newInstance();
			Transformer transformer = tFactory.newTransformer(new StreamSource(xslPath));

			StreamSource xmlSource = new StreamSource(new FileInputStream(new File(xmlPath)));
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			transformer.transform(xmlSource, new StreamResult(baos));

			res = baos.toString();

		} catch (Exception e) {
			e.printStackTrace();
		}

		asFile(res, outPath);

	}

	/**
	 * @param s     the string to be written as file
	 * @param fPath the (full) path to the file where the string should be written
	 *              to
	 */
	public static void asFile(String s, String fPath) throws FileNotFoundException {
		PrintWriter pw = new PrintWriter(new File(fPath));
		pw.write(s);
		pw.flush();
		pw.close();
	}

	/**
	 * 
	 * @param n the node to be written into the file
	 * @see #asFile(String, String)
	 */
	public static void asFile(Node n, String fPath) throws TransformerException, FileNotFoundException {
		String xml = asString(n);
		asFile(xml, fPath);

	}

	/**
	 * Write node content to standard output
	 */
	public static void dump(Node n) throws TransformerException {
		System.out.println(asString(n));
	}

	public static void main(String[] args) throws ParserConfigurationException, SAXException, IOException,
			TransformerException, XPathExpressionException {

		//xslTransform("data/piloten_all.xml", "data/pilot.xsl", "out/piloten.html");
		//xslTransform("data/OCR.xml", "data/OCR.xsl", "out/OCR.html");
		
		xslTransform("data/questionnaire.xml", "data/questionnaire.xsl", "out/questionnaire.html");
		
//		Document doc = XMLUtils.readXML("data/piloten_all.xml");
//		String s = XMLUtils.xPathResAsString(doc, "//Pilot[position() <= 10 and @id != 6]/Nachname", false);
//		System.out.println(s);
	}

}
