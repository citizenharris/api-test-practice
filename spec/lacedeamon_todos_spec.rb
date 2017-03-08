require 'httparty'
require 'json'

describe 'Lacedeamon API' do
url = 'http://lacedeamon.spartaglobal.com/todos'
  
  it 'should read the api and return a JSON' do
    response = HTTParty.get(url)
    expect(response).is_a? JSON
  end

  it 'should create a new todo' do
    response = HTTParty.post(url, query: {title: 'wax moustache', due: '2017-09-09'})
    expect(response.code).to eq 201
  end

  it 'should return an error if supplied a date earlier than 1970-01-01' do
    response = HTTParty.post(url, query: {title: 'wax moustache', due: '1967-09-09'})
    expect(response.code).to eq 405
  end

  it 'should return an error if supplied a date in the past' do
    response = HTTParty.post(url, query: {title: 'wax moustache', due: '1987-09-09'})
    expect(response.code).to eq 405
  end

  it 'should be able to create a todo with a duplicate title' do
    response = HTTParty.post(url, query: {title: 'wax moustache', due: '2017-09-09'})
    response = HTTParty.post(url, query: {title: 'wax moustache', due: '2027-09-09'})
    expect(response.code).to eq 201
  end

  it 'should delete a todo when given a delete request' do
    rp = HTTParty.post(url, query: {title: 'wax moustache', due: '1987-09-09'})
    rp = JSON.parse(rp.body)
    rp = rp['id']
    rp = HTTParty.delete("http://lacedeamon.spartaglobal.com/todos/#{rp}")
    expect(rp.code).to eq 204
  end

  it 'should overwrite a todo' do
    rp = HTTParty.post(url, query: {title: 'wax moustache', due: '2987-09-09'})
    rp = JSON.parse(rp.body)
    rp = rp['id']
    rp = HTTParty.put("http://lacedeamon.spartaglobal.com/todos/#{rp}", query: {title: 'wax moustache fiercely', due: '2017-09-09'})
    rp = JSON.parse(rp.body)
    expect(rp['title']).to eq 'wax moustache fiercely'
  end

  it 'should edit a todo' do
    rp = HTTParty.post(url, query: {title: 'oil beard', due: '2987-09-09'})
    rp = JSON.parse(rp.body)
    rp = rp['id']
    rp = HTTParty.patch("http://lacedeamon.spartaglobal.com/todos/#{rp}", query: {title: 'oil beard fiercely'})
    rp = JSON.parse(rp.body)
    expect(rp['title']).to eq 'oil beard fiercely'
  end

  it 'should not accept a word as a valid date format' do
    response = HTTParty.post(url, query: {title: 'wax moustache', due: 'bananarama'})
    expect(response.code).to eq 500
  end

  it 'should not accept American date format as a valid date format' do
    response = HTTParty.post(url, query: {title: 'wax moustache', due: '12-24-1978'})
    expect(response.code).to eq 500

  it 'should only accept a variant of yyyy-mm-dd as a valid date format' do
    response = HTTParty.post(url, query: {title: 'wax moustache', due: '99-09-09'})
    expect(response.code).to eq 405
  end
  end
end

