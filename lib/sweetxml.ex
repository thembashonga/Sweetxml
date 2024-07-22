defmodule SweetXml do
  # import SweetXml

  # xml = """
  #     <?xml version="1.0" encoding="utf-8"?>
  #     <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  #       <soap:Body>
  #         <Add xmlns="http://tempuri.org/">
  #           <intA>80</intA>
  #           <intB>20</intB>
  #         </Add>
  #       </soap:Body>
  #     </soap:Envelope>
  # """

  def xml(int_a, int_b) do
   ~s(<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <Add xmlns="http://tempuri.org/">
            <intA>#{int_a}</intA>
            <intB>#{int_b}</intB>
          </Add>
        </soap:Body>
      </soap:Envelope>)
  end

  def add_from_xml(int_a, int_b) do

    # IO.inspect("----lets see")
    #  int_a = xml |> xpath(~x"//Add/intA/text()"s) |> String.to_integer()
    #  int_b = xml |> xpath(~x"//Add/intB/text()"s) |> String.to_integer()

    xml(int_a, int_b)

  end


  def summation(int_a, int_b) do

    issue_params = add_from_xml(int_a, int_b)



    headers = %{

     "Content-Type" => "text/xml; charset=utf-8",
      "SOAPAction" => "http://tempuri.org/Add",

    }

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      timeout: 30_000,
      recv_timeout: 50_000,
      hackney: [:insecure]
    ]
    HTTPoison.post("http://www.dneonline.com/calculator.asmx", issue_params, headers, options)
    |> case do

        {:ok, response} ->

          IO.inspect(response, label: :pppppppppppppppp55)

          # results = response.body |> Poison.decode!()

          case response.status_code do
          200 ->
            {:ok, "SUCCESS"}
            _ ->
            {:ok, "FAILED"}
          end

      {:error, _reason} ->
        # IO.inspect(reason, label: :pppppppppppppppp22)

        {:error, "No Internet Connection"}
    end
  end
end
